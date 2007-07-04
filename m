Return-Path: <linux-kernel-owner+w=401wt.eu-S1760764AbXGDVqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760764AbXGDVqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 17:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757399AbXGDVqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 17:46:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40979 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755564AbXGDVqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 17:46:06 -0400
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] Scheduler profiling - Use immediate values
References: <20070703164046.645090494@polymtl.ca>
	<20070703164516.377240547@polymtl.ca>
	<20070704203532.GC5812@martell.zuzino.mipt.ru>
From: Andi Kleen <andi@firstfloor.org>
Date: 05 Jul 2007 00:41:36 +0200
In-Reply-To: <20070704203532.GC5812@martell.zuzino.mipt.ru>
Message-ID: <p73bqer3i73.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> writes:

> On Tue, Jul 03, 2007 at 12:40:56PM -0400, Mathieu Desnoyers wrote:
> > Use immediate values with lower d-cache hit in optimized version as a
> > condition for scheduler profiling call.
> 
> I think it's better to put profile.c under CONFIG_PROFILING as
> _expected_, so CONFIG_PROFILING=n users won't get any overhead, immediate or
> not. That's what I'm going to do after test-booting bunch of kernels.

No, it's better to handle this efficiently at runtime e.g. for 
distribution kernels. Mathieu's patch is good

-Andi
