Return-Path: <linux-kernel-owner+w=401wt.eu-S1763525AbYFZNPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763525AbYFZNPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758930AbYFZNOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:14:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56707 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761727AbYFZNOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:14:00 -0400
Date: Thu, 26 Jun 2008 15:13:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix pte allocation in "x86: introduce
	init_memory_mapping for 32bit"
Message-ID: <20080626131346.GA3545@elte.hu>
References: <48616800.8030603@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48616800.8030603@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0351]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> The patch "x86: introduce init_memory_mapping for 32bit" does not 
> allocate enough space for PTEs if the CPU does not implement PSE.

applied to tip/x86/unify-setup - thanks Jeremy!

	Ingo
