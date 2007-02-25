Return-Path: <linux-kernel-owner+w=401wt.eu-S964795AbXBYKqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964795AbXBYKqT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 05:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964800AbXBYKqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 05:46:19 -0500
Received: from mail28.syd.optusnet.com.au ([211.29.133.169]:34767 "EHLO
	mail28.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964795AbXBYKqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 05:46:18 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: 2.6.20-ck1
Date: Sun, 25 Feb 2007 21:32:14 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, ck mailing list <ck@vds.kolivas.org>
References: <200702162110.03355.kernel@kolivas.org> <200702242334.31864.gene.heskett@gmail.com>
In-Reply-To: <200702242334.31864.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702252132.15145.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 February 2007 15:34, Gene Heskett wrote:
> I have a problem, Con.  The patch itself works fine for me, BUT it doesn't
> update the version.h available in
> /lib/modules/2.6.20-ck1/source/include/linux to include the -ck1 in the
> reported kernel version when trying to build an fglrx driver with the
> latest ati driver builder.
> Which leaves this error message in /usr/share/fglrx/flgrx-install.log:
> [root@coyote fglrx]# cat fglrx-install.log
> [Message] Kernel Module : Trying to install a precompiled kernel module.
> [Message] Kernel Module : Precompiled kernel module version mismatched.
> [Message] Kernel Module : Found kernel module build environment,
> generating kernel module now.
> ATI module generator V 2.0
> ==========================
> initializing...
> Error:
> kernel includes at /lib/modules/2.6.20-ck1/build/include do not match
> current kernel.
> they are versioned as ""
> instead of "2.6.20-ck1".
> you might need to adjust your symlinks:
> - /usr/include
> - /usr/src/linux
> [Error] Kernel Module : Failed to compile kernel module - please consult
> readme.
> ==========================
> Unforch, the installer does not leave a readme behind that I've been able
> to find, nor does it report the error on-screen.
>
> The above files are not simlinks here on this FC6 install.  And of
> course /usr/src/linux does not exist allthough I could set it up for the
> duration of a rebuild/reinstall cycle of my script.
>
> Can we have a patch to address this?  Or should I just hardcode it since
> it will never be linked to any other later kernel?
>
> I tried that in the src tree's include/linux/version.h, but it was
> refreshed back to the original regex code by the make, so that's not
> where to do it obviously.  I've also made the simlink in /usr/src, but
> since a kernel make re-writes version.h, that didn't help.
>
> Whats next?

I've never heard of this problem before. As far as I'm aware the EXTRAVERSION 
usually is not included in version.h so it seems to be a limitation of the 
flgrx installer? That would mean the flgrx installer wouldn't work on any 
kernel with an extra version such as the -rc releases of mainline even. So 
I'm sorry but I don't really know what to do about this problem.

-- 
-ck
