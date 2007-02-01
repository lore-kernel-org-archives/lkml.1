Return-Path: <linux-kernel-owner+w=401wt.eu-S1422738AbXBASbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422738AbXBASbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 13:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422923AbXBASbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 13:31:42 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:52566 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422738AbXBASbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 13:31:41 -0500
X-Originating-Ip: 74.109.98.130
Date: Thu, 1 Feb 2007 13:30:24 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Judith Lebzelter <judith@osdl.org>, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, fastboot@osdl.org
Subject: Re: [ PATCH ] fix to documentation for kexec
In-Reply-To: <Pine.LNX.4.61.0702011923530.13737@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.64.0702011329550.16875@CPE00045a9c397f-CM001225dbafb6>
References: <20070201181955.GE5825@shell0.pdx.osdl.net>
 <Pine.LNX.4.61.0702011923530.13737@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Feb 2007, Jan Engelhardt wrote:

>
> >@@ -228,8 +228,8 @@ Notes on loading the dump-capture kernel
> > * You must specify <root-dev> in the format corresponding to the root
> >   device name in the output of mount command.
> >
> >-* "init 1" boots the dump-capture kernel into single-user mode without
> >-  networking. If you want networking, use "init 3."
> >+* Boot parameter "1" boots the dump-capture kernel into single-user mode
> >+  without networking. If you want networking, use "3".
>
> Yup. More precisely, any arguments that could not be parsed (because
> the kernel does not know them) are handed down to the init program
> as arguments and/or environment variables.

whoops, ignore my last post, i misread the critical words.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
