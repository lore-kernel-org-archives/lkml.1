Return-Path: <linux-kernel-owner+w=401wt.eu-S1754307AbZALOt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbZALOt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 09:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZALOts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 09:49:48 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:57636 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752064AbZALOtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 09:49:47 -0500
Date: Mon, 12 Jan 2009 15:49:36 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Matthias Kaehlcke <matthias@kaehlcke.net>
cc: phillip@lougher.demon.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [BUG?] SQUASHFS error: Major/Minor mismatch
In-Reply-To: <20090112140822.GB23365@traven>
Message-ID: <Pine.LNX.4.64.0901121548040.13607@vixen.sonytel.be>
References: <20090112140822.GB23365@traven>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2009, Matthias Kaehlcke wrote:
> i get the following error when trying to mount a squashfs partition on
> an ARM system (edb9302) with linux 2.6.29-rc1:
> 
> mount /dev/mtdblock6 /mnt/
> SQUASHFS error: Major/Minor mismatch, older Squashfs 3.1 filesystems
> are unsupported
> mount: mounting /dev/mtdblock6 on /mnt/ failed: Invalid argument
> 
> the image has been created using mksquashfs v3.4:
> 
> mksquashfs . /tmp/rootfs.squfs -le -noappend

You have to use a version of mksquashfs that creates file systems with the v4.0
layout, i.e. from the squashfs-tools on SourceForge.net:

    git-cvsimport -v -d :pserver:anonymous@squashfs.cvs.sourceforge.net:/cvsroot/squashfs squashfs

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
