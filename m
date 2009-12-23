Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbZLWSHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbZLWSHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 13:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbZLWSHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 13:07:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34402 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbZLWSHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 13:07:22 -0500
Subject: Re: SCHED: Is task migration necessary in sched_exec().
From: Peter Zijlstra <peterz@infradead.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <b9df5fa10912230452q6edac4d3wb837a2e550cc5092@mail.gmail.com>
References: <b9df5fa10912230214s3815c023g2a7e7ca152eb00e4@mail.gmail.com>
	 <1261563687.4937.120.camel@laptop>
	 <b9df5fa10912230246w4adf160bibc12d7c6480ce058@mail.gmail.com>
	 <1261565584.4937.124.camel@laptop>
	 <b9df5fa10912230335r459f86d4te868fca82b891752@mail.gmail.com>
	 <1261569112.4937.135.camel@laptop>
	 <b9df5fa10912230404p37edca22h54ef7dceec651de4@mail.gmail.com>
	 <1261570834.4937.141.camel@laptop>
	 <b9df5fa10912230452q6edac4d3wb837a2e550cc5092@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Dec 2009 19:06:43 +0100
Message-ID: <1261591603.4937.153.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-23 at 18:52 +0600, Rakib Mullick wrote:

> Yes - a fair win. But if load balancer moves other tasks from the runqueue
> (2nd or 3rd task from your ex.) and thats how we also can achive 1/2 of cpu1's
> time , right? Those waiting tasks could have effective 0 cache footprint too.
> If they were not run before - right?

Could have, but is very unlikely, and here we have one we know for sure.

