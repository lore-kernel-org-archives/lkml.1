Return-Path: <linux-kernel-owner+w=401wt.eu-S1758275AbYJGXn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbYJGXn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 19:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755845AbYJGXns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 19:43:48 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:31456 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672AbYJGXnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 19:43:47 -0400
Message-ID: <48EBF426.9080500@caviumnetworks.com>
Date: Tue, 07 Oct 2008 16:43:34 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
CC: "Paoletti, Tomaso" <Tomaso.Paoletti@caviumnetworks.com>
Subject: [PATCH 0/4] serial: 8250 driver improvements & Cavium OCTEON serial
 support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Oct 2008 23:43:34.0633 (UTC) FILETIME=[83376D90:01C928D6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a follow up to the 'Allow for replaceable I/O functions in
8250 driver' patch I sent yesterday.  I hope it addresses the issues
raised by Alan Cox and Arnd Bergmann.

The four parts of the patch are as follows:

1/4) Add replaceable I/O functions to the 8250 driver.  This allows
     platform specific register access code to be moved out of the
     driver into the platform support files.

2/4) Add a new port flag UPF_FIXED_TYPE that allows callers of
     serial8250_register_port() to specify the port type and disables
     probing.

3/4) Add a 'bugs' field to the serial8250_config.  Used in conjunction
     with 2/4, this allows the bugs flags to be set without probing.

4/4) Add an entry to uart_config for PORT_OCTEON describing the
     OCTEON's internal UARTs.  Two new bug flags are defined to
     account for PORT_OCTEON's peculiarities.

Comments welcome,

David Daney
