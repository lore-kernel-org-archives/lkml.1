Return-Path: <linux-kernel-owner+w=401wt.eu-S932530AbYBTWD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530AbYBTWD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757573AbYBTWDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:03:17 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:45285 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400AbYBTWDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:03:16 -0500
Date: Wed, 20 Feb 2008 23:03:26 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: sparse - make __CHECK_ENDIAN__ default enabled?
Message-ID: <20080220220326.GA22328@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harvey.

Can I ask you to look into the worst offenders so we
can make -D__CHECK_ENDIAN__ enabled per default
in the kernel.
Or maybe we should do it anyway?

I made a quick test-run with a x86 64 bit defconfig.
My first thought was that this was just really bad
because the amount of warnings roughly doubled.

But then inspecting it a little closer I could see
that 8 files had an increase of > 100 additional
warnings when we enabled __CHECK_ENDIAN__ and
that smells like easy targets to bring down the noise.

I did not dare do it for an allyesconfig run - I 
am not that brave.

Comments?

	Sam
