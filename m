Return-Path: <linux-kernel-owner+w=401wt.eu-S1761642AbYGORJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761642AbYGORJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757080AbYGORJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:09:01 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:16177 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756673AbYGORJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:09:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=user-agent:date:from:to:cc:subject:message-id;
        b=q/Xx3CW0NgbEoIqsrGk68orw7ujpr3xg4y71LX8VLzGgL3Jm7926J24TaSVpfAB0jt
         /rwKiKXjcqcQL6tbcEoDdDXjbo7g62ZHeO+dx5fKGqHASLAeM/CGJ14SkgdKtxmCzAJ0
         mrz/RrSR/Ibna/h10KbLwH1AsDCSz9GmNux/M=
User-Agent: quilt/0.46-1
Date: Tue, 15 Jul 2008 21:02:53 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, macro@linux-mips.org,
       yhlu.kernel@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [patch 0/2] -tip x86/apic helper for further merging
Message-ID: <487cd9a9.08074e0a.1dd7.20cd@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi, these two patches add calibrate_APIC_clock in 32bit code as
we have in 64bit code and make it to return error. I don't see
the way to make it simplier by now since 32bit code uses a few
clock sources.

  Also this contains already passed patch

	[RFC] lapic calibration results fix 
	http://lkml.org/lkml/2008/7/13/50

  Please review, any comments are welcome.

  The patches are made on top of -tip tree

	commit d093f36037d9f296c7886d11d3fd67ee4ca817b3
	Merge: ff8db60... a6784ad...
	Author: Ingo Molnar <mingo@elte.hu>
	Date:   Thu Jul 10 12:36:55 2008 +0200

	    Merge branch 'x86/core'

		- Cyrill -

-- 
