Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbZDPKSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbZDPKSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 06:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbZDPKSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 06:18:00 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:52793 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222AbZDPKR7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 06:17:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZqCHbGFwBy9a5TRwn0Ob+lcTAZj6GnQmtriQBnDbX5XX3tbXTMhaZAEi+YbTf/Eaj7
         VXGrHaCCMYUWfy8+oe4LdZCnVmuKhCUWiFgYPPQl2pb7sRkSAMdG4FJUzu4wP094IPky
         CBNiH+qMGFHRjMe0UqUbLBNojzA4H59qcdCKk=
MIME-Version: 1.0
In-Reply-To: <672927818@web.de>
References: <672927818@web.de>
Date: Thu, 16 Apr 2009 12:17:56 +0200
Message-ID: <2d05c4580904160317i2e5499d2ld7b4deb8ec312aa2@mail.gmail.com>
Subject: Re: Linux image boot
From: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
To: devzero@web.de
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey thanks roland,

the link is just what I was interested in. So GRUB does that loading
back and forth around
first 1 MB. I just looked at article:

http://duartes.org/gustavo/blog/post/how-computers-boot-up

and it says that there:
------------------------------------------------------------------------------
There’s a complication worth mentioning (aka, I told you this thing is
hacky). The image for a current Linux kernel, even compressed, does
not fit into the 640K of RAM available in real mode. My vanilla Ubuntu
kernel is 1.7 MB compressed. Yet the boot loader must run in real mode
in order to call the BIOS routines for reading from the disk, since
the kernel is clearly not available at that point. The solution is the
venerable unreal mode. This is not a true processor mode (I wish the
engineers at Intel were allowed to have fun like that), but rather a
technique where a program switches back and forth between real mode
and protected mode in order to access memory above 1MB while still
using the BIOS. If you read GRUB source code, you’ll see these
transitions all over the place (look under stage2/ for calls to
real_to_prot and prot_to_real). At the end of this sticky process the
loader has stuffed the kernel in memory, by hook or by crook, but it
leaves the processor in real mode when it’s done.
------------------------------------------------------------------------------

Thanks again,

Dragoslav Zaric
[Programmer; M Sc Astrophysics]
