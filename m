Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab0BRIMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 03:12:21 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52501 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab0BRIMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 03:12:20 -0500
To: Zachary Amsden <zamsden@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
       Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] x86 rwsem optimization extreme
From: Andi Kleen <andi@firstfloor.org>
References: <1266443901-3646-1-git-send-email-zamsden@redhat.com>
	<alpine.LFD.2.00.1002171403160.4141@localhost.localdomain>
	<4B7C7BE4.9050908@zytor.com>
	<alpine.LFD.2.00.1002171743200.4141@localhost.localdomain>
	<4B7C9F0A.1080708@zytor.com> <4B7CC14F.7000802@redhat.com>
Date: Thu, 18 Feb 2010 09:12:17 +0100
In-Reply-To: <4B7CC14F.7000802@redhat.com> (Zachary Amsden's message of "Wed, 17 Feb 2010 18:25:51 -1000")
Message-ID: <87iq9v55em.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden <zamsden@redhat.com> writes:
>
> Incidentally, the cost of putting all the rwsem code inline, using the
> straightforward approach, for git-tip, using defconfig on x86_64 is
> 3565 bytes / 20971778 bytes total, or 0.0168%, using gcc 4.4.3.

The nice advantage of putting lock code inline is that it gets 
accounted to the caller in all profilers.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
