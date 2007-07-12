Return-Path: <linux-kernel-owner+w=401wt.eu-S937356AbXGLAmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937356AbXGLAmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763755AbXGLAlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:41:51 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:15900 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759651AbXGLAlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:41:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=F9Nv2Yl53oEkgyOuxsc4kscHe8r3HsFWEUuW3CG5UfMmlB5nKaBR2dMW8vJzi2AcLwGjnC+4QAAZA/3nTr9w15mkTE75LnOmckFuaMGPEU+v8lsmKcEdiyU7a1cILF9TtL2pl94mZ/GkUHm8ld+CW96JIAzL0rqTsA6pAufGuQg=
Message-ID: <21d7e9970707111741v6518d887j76bb80616dc1262a@mail.gmail.com>
Date: Thu, 12 Jul 2007 10:41:49 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.sourceforge.net>
Subject: Linux drm "war on typedefs"
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus has decreed the evil of typedefs in the kernel, and the DRM is
the proud winner of the "HEY MA: I CAN USE TYPEDEF" award,

So I've cleaned up most of the typedefs in the Linux drm core (I did
this in the kernel tree as I'd like to push it there first and
backport it to the hell of the DRM git tree :-)

http://master.kernel.org/git/?p=linux/kernel/git/airlied/drm-2.6.git;a=shortlog;h=drm-mm

Is my tree so far, with the core typedefs removed, the drivers have a
bunch more.

One thing is a lot of these have been used in userspace so are part of
the API, I've left these in the header surrounded by #ifndef
__KERNEL__ so I can keep them synced easily with the other users..

I think I should get this upstream in this merge window as it'll
probably bust a few patches from other places..

Dave.
