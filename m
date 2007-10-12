Return-Path: <linux-kernel-owner+w=401wt.eu-S1762098AbXJLW6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762098AbXJLW6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760712AbXJLWW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:22:58 -0400
Received: from mylar.outflux.net ([69.93.193.226]:54902 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760622AbXJLWW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:22:57 -0400
Date: Fri, 12 Oct 2007 14:42:27 -0700
From: Kees Cook <kees@ubuntu.com>
To: linux-kernel@vger.kernel.org
Subject: static LSM objection
Message-ID: <20071012214227.GY10703@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Outflux
X-HELO: gorgon.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just wanted to voice my opinion about the static LSM changes.
(I apologize about being late[1] to the discussion[2] -- I'd only recently
become aware of it.)  I'm personally really against this.  For example,
I want to give people choice about their security protections in Ubuntu,
and I'd like to let them pick the MAC that suits their needs.

Some people want SELinux, some people want AppArmor.  (Yes, I know
AppArmor isn't in mainline yet, but it does seem they're getting closer --
three distros are shipping AppArmor.  The static changes feel motivated
by political rather than technical reason -- though it of course have
technical merit.)  Considering things like SMACK and TOMOYO, it is going
to be very troublesome for distros to have to start building multiple
kernels to support each given MAC that their users want to use.

So, unless this is just re-hashing and you can point me to discussion
points I missed, can someone help me understand the technical issues
around this change?  It sounds like the primary reason for making it
non-modular is performance loss due to call overhead.  Aren't there
other ways to solve this without removing the boot-time module choice?
(Make it unloadable?)

I'm not convinced that the advantages of making it static out-weigh the
benefit of having it as a choice at boot-time.  (I don't really mind
needing a reboot to switch MAC implementations, as long as there is some
benefit from making them unloadable, though it sounds like there are
people would are against making LSMs unloadable too.)

Thanks,

-Kees

/me pops the safety off his fire extinguisher

[1] http://lkml.org/lkml/2007/7/19/228
[2] http://lkml.org/lkml/2007/7/14/91

-- 
Kees Cook
