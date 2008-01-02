Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbYABWNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbYABWNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 17:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbYABWNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 17:13:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866AbYABWND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 17:13:03 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH -mm] compat_binfmt_elf Kconfig
In-Reply-To: Sam Ravnborg's message of  Wednesday, 2 January 2008 22:53:11 +0100 <20080102215311.GA12558@uranus.ravnborg.org>
References: <20071223183920.GA13976@elte.hu>
	<20071223211603.3FFB126F8E7@magilla.localdomain>
	<20071230163614.GB1384@elte.hu>
	<20080102044157.A5CC526F99F@magilla.localdomain>
	<20080102111431.GD14731@elte.hu>
	<20080102191030.GA11217@uranus.ravnborg.org>
	<20080102210831.9F80426F9A0@magilla.localdomain>
	<20080102215311.GA12558@uranus.ravnborg.org>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080102221228.C9D8D26F9A0@magilla.localdomain>
Date: Wed,  2 Jan 2008 14:12:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have no opinions about the config symbol names.  Among the existing
precedents for internal/descriptionless symbols I find more not using the
HAVE_ prefix than those using it.  The patch versions I've sent now work
fine, fix the parallel build problem people were seeing, and AFAICT follow
the style of what's already in common use.  At this point, I think it would
be easiest just to keep them and have you send symbol-renaming patches
for any and all symbols of this sort that concern you as separate cleanups.


Thanks,
Roland
