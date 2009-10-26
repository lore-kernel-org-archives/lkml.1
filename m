Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbZJZByE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbZJZByE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 21:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbZJZByD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 21:54:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53435 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503AbZJZBx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 21:53:59 -0400
Subject: Re: [PATCH 3/3] sched: Disable affine wakeups by default
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <1256508287.17306.14.camel@marge.simson.net>
References: <20091024125853.35143117@infradead.org>
	 <20091024130432.0c46ef27@infradead.org>
	 <20091024130728.051c4d7c@infradead.org>
	 <1256453725.12138.40.camel@marge.simson.net>
	 <20091025095109.449bac9e@infradead.org>
	 <1256492289.14241.40.camel@marge.simson.net>
	 <20091025123319.2b76bf69@infradead.org>
	 <1256508287.17306.14.camel@marge.simson.net>
Content-Type: text/plain
Date: Mon, 26 Oct 2009 02:53:55 +0100
Message-Id: <1256522035.7356.19.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-10-25 at 23:04 +0100, Mike Galbraith wrote:
>                 if (want_affine && (tmp->flags & SD_WAKE_AFFINE) &&
> -                   cpumask_test_cpu(prev_cpu, sched_domain_span(tmp))) {
> +                               (level == SD_LV_SIBLING || level == SD_LV_MC)) {

quick comment without actually having looked at the patch, we should
really get rid of sd->level and encode properties of the sched domains
in sd->flags.

