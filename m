Return-Path: <linux-kernel-owner+w=401wt.eu-S936785AbZDJLwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936785AbZDJLwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 07:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936048AbZDJLvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 07:51:42 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:58901 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936062AbZDJLvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 07:51:39 -0400
Message-Id: <20090408133126.180521064@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Wed, 08 Apr 2009 22:31:26 +0900
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [TOMOYO 0/2] Final patches for kenrel 2.6.30.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TOMOYO Linux was merged into the mainline in 2.6.29-git1.

We thank Satoru Ueda for giving us opportunities to have presentations at CE
Linux Forum's Japan Technical Jamboree. This was the first event that we were
taught what the mainline is.

We thank Hirotaka Yoshioka for giving us opportunities to have presentations at
YLUG kernel code reading party. This was the very event that we were
foreordained to challenge the mainline. Without this event, we would not have
started the challenge for the mainline.

We thank James Morris for coming to Linux Foundation Japan Symposium #8 and
Linux Conf Au 2009 and understanding why name based security is needed.

We thank Casey Schaufler for proving that new security modules can merge into
the mainline.

We thank Stephen Smalley for coming to Ottawa Linux Symposium 2007/2008 and
giving us a critical comment that extricated ourselves from our stagnation.

We thank Andrew Morton for listening to our problem when we were blocked by
the lack of new LSM hooks.

We thank Al Viro for accepting new LSM hooks which made TOMOYO possible to
merge into the mainline.

We thank Crispin Cowan for proposing AppArmor. We were able to have a chance to
understand why name based security is regarded as an inferior solution.
We continued the name based security, with our belief that inode based security
and name based security are complementary and both should be used together.
The gate for name based security opened. Go for it!

We thank Turbolinux for adopting TOMOYO into Turbolinux's products.

We thank Mandriva Linux for adopting TOMOYO into Mandriva Linux's products.

We thank Hideaki Yoshifuji for giving us advices on how to negotiate.

We thank Motohiro Kosaki for giving us advices on how to write patch comments.

We thank Fumihito Yoshida for supporting TOMOYO in Ubuntu.

We thank Hideki Yamane for supporting TOMOYO in Debian.

We thank Naohiro Aota for supporting TOMOYO in Gentoo.

We thank Ken-ichi Akimoto for supporting TOMOYO in Natures Linux.

We thank Vadim Korschok for using TOMOYO on Hardened Gentoo.

We thank Hiroshi Shinji for using TOMOYO on embedded systems and
requesting new features and helping debugging.

We thank Toru Hirasaka for developing TOMOYO's GUI policy editor.

We thank Yoshihiro Kusuno for enhancing TOMOYO's CUI policy editor.

We thank Masafumi Tanaka for drawing posters and developing demonstration
movies.

We thank Akira Igarashi for drawing TOMOYO's logo and drawing many
illustrations for presentations.

We thank Kohei Kaigai for coordinating various open source events.

We thank Japan Secure Operating System Users Group for giving us opportunities
to familiarize SELinux, TOMOYO, AppArmor, LIDS etc. in Japan.

We thank anonymous users giving us suggestions and comments and feature
requests on 2ch.net and sourceforge.jp and blogs. TOMOYO achieved 30,000
downloads since the release of TOMOYO Linux version 1.0 on 2005/11/11.

We thank Dragos Ruiu for giving us opportunities to have presentations at
PacSec conference 2007/2008.

We thank Jonathan Corbet for writing many articles on TOMOYO at LWN.net ever
since Embedded Linux Conference 2007.

We thank CLAMP for creating Card Captor Sakura. TOMOYO's idea was taken from
the Sakura's happy world.

We thank SourceForge.jp for providing us storages and services.

We thank NTT DATA CORPORATION for supporting us in development of TOMOYO.

We thank Linus Torvalds for allowing us to join the Linux community.

With many more thanks, we would like to release this snapshot as TOMOYO Linux
version 2.2.0. Thank you for waiting.

--
Kentaro Takeda
Tetsuo Handa
Toshiharu Harada

