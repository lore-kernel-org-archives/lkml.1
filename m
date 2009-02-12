Return-Path: <linux-kernel-owner+w=401wt.eu-S1759423AbZBLQBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759423AbZBLQBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 11:01:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbZBLQA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 11:00:56 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:56387 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbZBLQAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 11:00:55 -0500
Date: Thu, 12 Feb 2009 17:00:54 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: John Ogness <dazukocode@ogness.net>
cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       malware-list@lists.printk.net, eparis@redhat.com, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCHv2 2/5] VFS: DazukoFS, stackable-fs, file access control
In-Reply-To: <86wsc7fhzc.fsf_-_@johno.fn.ogness.net>
Message-ID: <alpine.LSU.2.00.0902121659460.5658@fbirervta.pbzchgretzou.qr>
References: <8663jrgwo4.fsf@johno.fn.ogness.net> <861vufgwlt.fsf@johno.fn.ogness.net> <86wsc7fhzc.fsf_-_@johno.fn.ogness.net>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2009-02-03 20:17, John Ogness wrote:
>Index: linux-2.6.28/Documentation/filesystems/dazukofs.txt
>===================================================================
>--- linux-2.6.28.orig/Documentation/filesystems/dazukofs.txt	2009-02-03 18:07:44.000000000 +0100
>+++ linux-2.6.28/Documentation/filesystems/dazukofs.txt	2009-02-03 18:10:46.000000000 +0100
>@@ -2,9 +2,10 @@
>+
>+By opening the device /dev/dazukofs.0 an application has registered itself.
>+A read on the device will block until a file access event on DazukoFS has
>+taken place. When a file access event has occured, the read will return with
>+information about the file access event. For example:

Given that there are more device files to come, I would
put this into a separate directory, /dev/dazukofs/0, much
like dm-crypt does for its devices.
