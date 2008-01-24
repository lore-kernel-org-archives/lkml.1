Return-Path: <linux-kernel-owner+w=401wt.eu-S1756488AbYAXPV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbYAXPV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 10:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbYAXPVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 10:21:19 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55970 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752886AbYAXPVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 10:21:18 -0500
Date: Thu, 24 Jan 2008 15:19:03 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Marcin Gil <marcin.gil@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: JMicron PATA 2.6.24-rc7 can't find drives
Message-ID: <20080124151903.17e28e87@lxorguk.ukuu.org.uk>
In-Reply-To: <479839B4.3060202@gmail.com>
References: <200801232323.36187.marcin.gil@gmail.com>
	<20080123234639.025cc859@lxorguk.ukuu.org.uk>
	<479839B4.3060202@gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The output of dmesg after the boot would be a good start
> 
> Here it is:
> http://pastebin.com/md726431

Ok that is the important bit:

ata9: port is slow to respond, please be patient (Status 0x80)
ata9: SRST failed (errno=-16)

So when we reset the interface and probed it the HDD on the Jmicron
interface decided it didn't want to talk to us. What make/model of disk
is this ?
