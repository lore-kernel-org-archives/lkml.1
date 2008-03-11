Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbYCKIwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbYCKIwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 04:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbYCKIw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 04:52:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48705 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbYCKIwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 04:52:25 -0400
Date: Tue, 11 Mar 2008 09:52:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/2] Revert "cpu hotplug: adjust root-domain->online
	span in response to hotplug
Message-ID: <20080311085201.GD25110@elte.hu>
References: <20080310205241.9571.38832.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080310205241.9571.38832.stgit@novell1.haskins.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Gregory Haskins <ghaskins@novell.com> wrote:

> This reverts commit 393d94d98b19089ec172566e23557997931b137e.
> 
> I submitted 393d94d98b1 to -mm and sched-devel, and then quickly 
> realized it was flawed.  However, the patch was already "in flight" 
> and made it to Linus' tree and is in .25-rc5.  So this patch reverts 
> the original/flawed fix, and the patch that follows has the updated 
> version.

yeah, but the patch fixed Andrew's regression and passed my testing so i 
wanted to have _something_ in -rc5, even if we found the right fix.

i've applied your revert and the real fix now.

	Ingo
