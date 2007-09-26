Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbXIZNOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbXIZNOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 09:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbXIZNOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 09:14:03 -0400
Received: from mail-03.jhb.wbs.co.za ([196.2.97.2]:32941 "EHLO
	mail-03.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbXIZNOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 09:14:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuE6ABT2+UbEAmHERmdsb2JhbACOJgEBARIKGQ4
From: Bongani Hlope <bonganilinux@mweb.co.za>
To: David Newall <david@davidnewall.com>
Subject: Re: Chroot bug
Date: Wed, 26 Sep 2007 15:13:52 +0200
User-Agent: KMail/1.9.7
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>,
       Bill Davidsen <davidsen@tmr.com>, Philipp Marek <philipp@marek.priv.at>,
       7eggert@gmx.de, majkls <majkls@prepere.com>, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
References: <56705.193.171.152.61.1190289559.squirrel@webmail.marek.priv.at> <20070926114729.3b9d1fb4@the-village.bc.nu> <46FA3D4B.20805@davidnewall.com>
In-Reply-To: <46FA3D4B.20805@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709261513.52883.bonganilinux@mweb.co.za>
X-Original-Subject: Re: Chroot bug
X-Scan-Signature: 0709da36597123c7590b13156936bcc5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 September 2007 13:06:51 David Newall wrote:
> Alan Cox wrote:
> >>> The dot-dot entry in the root directory is interpreted to mean the
> >>> root directory itself. Thus, dot-dot cannot be used to access files
> >>> outside the subtree rooted at the root directory.
> >
> > Which is behaviour chroot preserves properly.
>
> And yet it is the dot-dot entry which is used to access files outside
> the root.
>
> > The specification says explicitly
> >
> > 	"The process working directory is unaffected by chroot()."
>
> Do you believe that when those words were first written, the hidden
> conflict, namely that it permits dot-dot to access files outside the
> subtree, was understood?  They would have said so if that were the case.

You seem to be misunderstanding what Alan is trying to say to you, if your 
program calls chroot, it's working directory is unaffected. Programs that are 
started in the chrooted root, will be affected.

i.e. if you run chroot in bash, the bash process's CWD is not affected and 
bash can escape the chrooted root, but if you run ls .., it will not escape.

If you do not get too emotional, you tend to understand what people are trying 
to say.
