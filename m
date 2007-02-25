Return-Path: <linux-kernel-owner+w=401wt.eu-S1752436AbXBYVDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbXBYVDG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 16:03:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbXBYVDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 16:03:06 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60564 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbXBYVDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 16:03:04 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Zwane Mwaikambo <zwane@infradead.org>, Ashok Raj <ashok.raj@intel.com>,
       Ingo Molnar <mingo@elte.hu>, "Lu, Yinghai" <yinghai.lu@amd.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 12/14] x86_64 irq: Add constants for the reserved IRQ vectors.
References: <m1ps81uno3.fsf_-_@ebiederm.dsl.xmission.com>
	<m1lkipunl0.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ejohung7.fsf_-_@ebiederm.dsl.xmission.com>
	<m17iu9unb6.fsf_-_@ebiederm.dsl.xmission.com>
	<m13b4xun1c.fsf_-_@ebiederm.dsl.xmission.com>
	<m1y7mpt8d2.fsf_-_@ebiederm.dsl.xmission.com>
	<m1tzxdt8au.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps81t87h.fsf_-_@ebiederm.dsl.xmission.com>
	<20070225104327.GF2045@elf.ucw.cz>
	<m1wt26pjxp.fsf@ebiederm.dsl.xmission.com>
	<20070225194817.GB1746@elf.ucw.cz>
Date: Sun, 25 Feb 2007 14:01:19 -0700
In-Reply-To: <20070225194817.GB1746@elf.ucw.cz> (Pavel Machek's message of
	"Sun, 25 Feb 2007 20:48:17 +0100")
Message-ID: <m1irdqostc.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

> BUILD_BUG_ON(x > 15) ? ;-).

That might work.  Can you use that in a constant expression?
Still it is a complexity for a  handful of lines.

I would prefer to go with something simple at this point.

Eric
