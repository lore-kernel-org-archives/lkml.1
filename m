Return-Path: <linux-kernel-owner+w=401wt.eu-S1757969AbZASRhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbZASRhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbZASRgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:36:54 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41624 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752210AbZASRgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:36:53 -0500
Date: Mon, 19 Jan 2009 17:37:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] ide: move SFF I/O code to ide-io-sff.c
Message-ID: <20090119173701.13fd24c6@lxorguk.ukuu.org.uk>
In-Reply-To: <49748E43.4030009@ru.mvista.com>
References: <20090119130309.24745.40877.sendpatchset@localhost.localdomain>
	<20090119130322.24745.76137.sendpatchset@localhost.localdomain>
	<49748B95.9080105@ru.mvista.com>
	<200901191523.15240.bzolnier@gmail.com>
	<49748E43.4030009@ru.mvista.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > [ I'm also not happy with the naming but couldn't think of a better one. ]
> 
>     Legacy perhaps?

Legacy to most people means either ISA/VLB or the PCI legacy
compatibility mode so that would be confusing.

BTW if you moved to ioreadX you could get rid of almost all the readb/inb
special casing.
