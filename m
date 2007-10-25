Return-Path: <linux-kernel-owner+w=401wt.eu-S1759918AbXJYLeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759918AbXJYLeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 07:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbXJYLeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 07:34:03 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:40460 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbXJYLeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 07:34:01 -0400
Date: Thu, 25 Oct 2007 13:33:58 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andreas Gruenbacher <agruen@suse.de>,
       Bernd Petrovitsch <bernd@firmix.at>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>, James Morris <jmorris@namei.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-security-module@vger.kernel.org, Ray Lee <ray-lk@madrabbit.org>,
       Simon Arlott <simon@fire.lp0.eu>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>
Subject: Re: LSM conversion to static interface
Message-ID: <Pine.LNX.4.64.0710251328150.17781@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



As I read through LWN today, I noted the following comment, 
http://lwn.net/Articles/255832/ :

	Personally, I think it's absolutely essential to be able to 
	build a kernel with dynamic LSM. Whether we like it or not, 
	people do want to add in runtime loadable security modules for 
	things like virus scanners, and until upstream offers these 
	folks a viable alternative to LSM...well, they'll use it.

Which reminded me of the TuxGuardian LSM[1] - another of the real-world 
uses to meet Linus's criteria? ("had examples of their real-world use to 
step forward and explain their use")

In this specific project, LSM is used to collect up calls to bind() and 
connect() and pass them to userspace, e.g. do it ZoneAlarm-style and 
display a dialog window. Its codebase is probably not too up-to-date 
(website says last change last April - but I guess that's a no-brainer 
to update it).

[1] http://tuxguardian.sf.net/
