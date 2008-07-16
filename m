Return-Path: <linux-kernel-owner+w=401wt.eu-S1760051AbYGPQ2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051AbYGPQ2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 12:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757502AbYGPQ2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 12:28:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58454 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757490AbYGPQ2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 12:28:16 -0400
Date: Wed, 16 Jul 2008 18:28:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] - Fix kernel_physical_mapping_init() for large x86
	systems
Message-ID: <20080716162800.GB19566@elte.hu>
References: <20080716161159.GA23870@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716161159.GA23870@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jack Steiner <steiner@sgi.com> wrote:

> Fix bug in kernel_physical_mapping_init() that causes kernel page 
> table to be built incorrectly for systems with greater than 512GB of 
> memory.
> 
> Signed-off-by: Jack Steiner <steiner@sgi.com>

applied to tip/x86/urgent - thanks Jack.

	Ingo
