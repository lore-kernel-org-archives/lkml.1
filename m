Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbXLEJeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbXLEJeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 04:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbXLEJe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 04:34:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47524 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578AbXLEJe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 04:34:27 -0500
Date: Wed, 5 Dec 2007 10:34:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Subject: SCHED - Use a 2-d bitmap for searching
	lowest-pri CPU
Message-ID: <20071205093412.GA17911@elte.hu>
References: <20071205025137.4494.18683.stgit@novell1.haskins.net> <20071205025538.4494.52380.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071205025538.4494.52380.stgit@novell1.haskins.net>
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

> The current code use a linear algorithm which causes scaling issues on 
> larger SMP machines.  This patch replaces that algorithm with a 
> 2-dimensional bitmap to reduce latencies in the wake-up path.

hm, what kind of scaling issues - do you have any numbers? What workload 
did you measure and on what hardware?

	Ingo
