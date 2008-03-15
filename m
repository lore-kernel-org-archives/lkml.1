Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158AbYCOM5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbYCOM5y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 08:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYCOM5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 08:57:45 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44960 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751706AbYCOM5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 08:57:44 -0400
Date: Sat, 15 Mar 2008 12:36:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/12] ali14xx: add "vlb_clock=" parameter
Message-ID: <20080315123614.6c548306@the-village.bc.nu>
In-Reply-To: <20080313224352.7051.44005.sendpatchset@localhost.localdomain>
References: <20080313224352.7051.44005.sendpatchset@localhost.localdomain>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 23:43:52 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> Add "vlb_clock=" parameter for specifying VLB clock frequency (in MHz).
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Surely this value should be set once per system (ditto for PCI) not
something you have to set in each specific driver on the box ?
