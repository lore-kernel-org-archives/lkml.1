Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbXB0UlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbXB0UlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 15:41:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbXB0UlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 15:41:01 -0500
Received: from email13.mywebmailserver.com ([199.231.136.143]:3995 "EHLO
	email13.mywebmailserver.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752563AbXB0Uk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 15:40:59 -0500
Message-ID: <45E49759.6050301@kuchera.com>
Date: Tue, 27 Feb 2007 15:40:57 -0500
From: Rob Prowel <prowel@kuchera.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070223 Fedora/1.0.8-0.5.1.fc5 SeaMonkey/1.0.8
MIME-Version: 1.0
To: Stuart MacDonald <stuartm@connecttech.com>
CC: "'Russell King'" <rmk+lkml@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: questions about 8250 uart support for adhoc boards
References: <028501c75aa2$54ae9d80$294b82ce@stuartm>
In-Reply-To: <028501c75aa2$54ae9d80$294b82ce@stuartm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Feb 2007 20:40:57.0608 (UTC) FILETIME=[956D1880:01C75AAF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stuart MacDonald wrote:
> Would it be more intuitive to give ports the default uartclk of
> 1843200 at init time? That would avoid this issue, but would make the
> baud rates come out wrong on hardware with a non-standard clock, if a
> base baud wasn't specified.
>
>   

I prefer the option to specify the base baud rate in setserial from a 
startup script.  Having the additional ports at BAUD 0 (unusable) until 
some explicit action is taken strikes me as a safer option, provided 
this gets properly documented in the kernel Documentation directory and 
in Linux HOWTO docs.

-Rob Prowel




