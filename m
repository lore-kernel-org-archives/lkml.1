Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334AbZGLJZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbZGLJZz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 05:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbZGLJZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 05:25:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54335 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbZGLJZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 05:25:46 -0400
To: Arjan van de Ven <arjan@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Siarhei Liakh <sliakh.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-cris-kernel@axis.com
Subject: Re: [PATCH v5] RO/NX protection for loadable kernel modules
From: Andi Kleen <andi@firstfloor.org>
References: <817ecb6f0907081610p6d60341cudbee42685eac1347@mail.gmail.com>
	<200907111821.47769.rusty@rustcorp.com.au>
	<20090711084958.69ff9196@infradead.org>
	<200907121410.39874.rusty@rustcorp.com.au>
	<20090712004524.2f0c4e57@infradead.org>
Date: Sun, 12 Jul 2009 11:25:45 +0200
In-Reply-To: <20090712004524.2f0c4e57@infradead.org> (Arjan van de Ven's message of "Sun, 12 Jul 2009 00:45:24 -0700")
Message-ID: <87ocrq9rs6.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:
>
> or using a non-power-of-two get_free_pages() thing...

alloc_pages_exact(). Was developed for exactly this purpose originally.

But it doesn't work on x86-64 again for modules.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
