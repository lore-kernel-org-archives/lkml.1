Return-Path: <linux-kernel-owner+w=401wt.eu-S1755144AbZALPGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbZALPGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 10:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbZALPGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 10:06:12 -0500
Received: from mailbox-us-s-12.mailhostingserver.com ([75.125.101.9]:35050
	"EHLO mailbox-us-s-12.mailhostingserver.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751327AbZALPGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 10:06:11 -0500
Date: Mon, 12 Jan 2009 16:06:02 +0100
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: phillip@lougher.demon.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [BUG?] SQUASHFS error: Major/Minor mismatch
Message-ID: <20090112150602.GC23365@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	phillip@lougher.demon.co.uk, linux-kernel@vger.kernel.org
References: <20090112140822.GB23365@traven> <Pine.LNX.4.64.0901121548040.13607@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0901121548040.13607@vixen.sonytel.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Mon, Jan 12, 2009 at 03:49:36PM +0100 Geert Uytterhoeven ha dit:

> On Mon, 12 Jan 2009, Matthias Kaehlcke wrote:
> > i get the following error when trying to mount a squashfs partition on
> > an ARM system (edb9302) with linux 2.6.29-rc1:
> > 
> > mount /dev/mtdblock6 /mnt/
> > SQUASHFS error: Major/Minor mismatch, older Squashfs 3.1 filesystems
> > are unsupported
> > mount: mounting /dev/mtdblock6 on /mnt/ failed: Invalid argument
> > 
> > the image has been created using mksquashfs v3.4:
> > 
> > mksquashfs . /tmp/rootfs.squfs -le -noappend
> 
> You have to use a version of mksquashfs that creates file systems with the v4.0
> layout, i.e. from the squashfs-tools on SourceForge.net:
> 
>     git-cvsimport -v -d :pserver:anonymous@squashfs.cvs.sourceforge.net:/cvsroot/squashfs squashfs

thanks to both of you for the pointer!

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

    Ma patrie est où je suis, où personne ne me dérange, où personne
    ne me demande que je suis, d'où je viens et ce que je fais
                              (B. Traven)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
