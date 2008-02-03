Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbYBCS1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbYBCS1S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 13:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbYBCS1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 13:27:01 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:41356 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbYBCS1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 13:27:00 -0500
Date: Sun, 3 Feb 2008 21:29:52 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Miklos Szeredi <mszeredi@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       William Lee Irwin III <wli@holomorphy.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [PATCH] sys_remap_file_pages: fix ->vm_file accounting
Message-ID: <20080203182952.GB5827@tv-sign.ru>
References: <20080130142014.GA2164@tv-sign.ru> <1201712101.31222.22.camel@tucsk.pomaz.szeredi.hu> <20080130172646.GA2355@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130172646.GA2355@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Off-topic question to all. sys_remap_file_pages() doesn't work with
shared readonly mappings, why?

IOW, why it checks VM_SHARED but not VM_MAYSHARE?

Thanks in advance,

Oleg.

