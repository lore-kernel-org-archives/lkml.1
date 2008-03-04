Return-Path: <linux-kernel-owner+w=401wt.eu-S1764851AbYCDV2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764851AbYCDV2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 16:28:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755184AbYCDV2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 16:28:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33797 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230AbYCDV2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 16:28:36 -0500
Date: Tue, 4 Mar 2008 22:28:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: preempt bug in set_pmd_pfn?
Message-ID: <20080304212821.GB8944@elte.hu>
References: <47CDBB87.8090906@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CDBB87.8090906@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0370]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> I think set_pmd_pfn, which is only called by __set_fixmap, might have 
> a preempt bug in it.

yes, and we had similar preemption bugs in the past. I guess most places 
are either infrequent or have some natural atomicity anyway. Wanna send 
a patch?

	Ingo
