Return-Path: <linux-kernel-owner+w=401wt.eu-S933230AbZLJGVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230AbZLJGVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 01:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933189AbZLJGVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 01:21:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57143 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933148AbZLJGVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 01:21:46 -0500
Date: Thu, 10 Dec 2009 07:20:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
       "David T.L. Wong" <davidtlwong@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org
Subject: Re: [GIT PULL for 2.6.33] V4L/DVB updates
Message-ID: <20091210062015.GA29594@elte.hu>
References: <20091209021639.14f08856@pedra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091209021639.14f08856@pedra>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

FYI, there's a new build failure on 32-bit x86 caused by the new max2165 
tuner driver:

drivers/built-in.o: In function `max2165_set_params':
max2165.c:(.text+0x486293): undefined reference to `__floatunsidf'
max2165.c:(.text+0x4862bc): undefined reference to `__floatunsidf'
max2165.c:(.text+0x4862c5): undefined reference to `__adddf3'
max2165.c:(.text+0x4862cf): undefined reference to `__fixunsdfsi'

	Ingo
