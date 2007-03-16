Return-Path: <linux-kernel-owner+w=401wt.eu-S1753666AbXCPX0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbXCPX0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 19:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbXCPX0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 19:26:20 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:43266 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbXCPX0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 19:26:19 -0400
Date: Sat, 17 Mar 2007 00:09:19 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Zachary Amsden <zach@vmware.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jan Beulich <jbeulich@novell.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: [RFC, PATCH] Fixup COMPAT_VDSO to work with CONFIG_PARAVIRT
In-Reply-To: <45FA16FE.7010805@vmware.com>
Message-ID: <Pine.LNX.4.61.0703170008380.23117@yvahk01.tjqt.qr>
References: <45FA054F.6020107@vmware.com> <45FA0D13.6080601@goop.org>
 <45FA16FE.7010805@vmware.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 15 2007 20:03, Zachary Amsden wrote:
> Well testing that is not so fun.  I installed SUSE Pro 9.0, and strings on
> ld.so contains the magic at_sysinfo assert!  But it doesn't install TLS
> libraries, so I'll have to install them by hand.

9.0 is kinda old. And if you want some TLS libs, install the _i686_ glibc
package (not done by default).


Jan
-- 
