Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbYCATRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbYCATRS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 14:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbYCATRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 14:17:05 -0500
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:48789 "EHLO
	marquesa.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753102AbYCATRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 14:17:04 -0500
X-Greylist: delayed 1738 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Mar 2008 14:17:03 EST
To: Pawel Plociennik <paplociennik@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] chroot= as a new kernel parameter
References: <200803011409.59526.paplociennik@gmail.com>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Sat, 01 Mar 2008 15:47:53 -0300
In-Reply-To: <200803011409.59526.paplociennik@gmail.com> (Pawel Plociennik's message of "Sat\, 1 Mar 2008 14\:09\:59 -0500")
Message-ID: <orejauxova.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar  1, 2008, Pawel Plociennik <paplociennik@gmail.com> wrote:

> In the short this patch has added a new chroot= kernel parameter
> which can be used to changing a chroot of an init process before it
> will has been runed.

Hey, this is cool, I've wanted something like this for a long time.
However, I was thinking of implementing it in mkinitrd, not in the
kernel proper.

OT1H, having it in the kernel proper makes it easier to support even
on distros whose mkinitrd doesn't support this stuff, or that don't
even use an initrd.  OTOH, having it in mkinitrd means you can use
this even on distros whose kernels don't support chroot=.

And then, given that booting up a kernel from one distro on another
requires setting up /lib/modules for proper functioning (unless your
mkinitrd does that for you, which is something else I've been thinking
of doing for similar reasons), I figured changing mkinitrd might be a
better way to go.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
