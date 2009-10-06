Return-Path: <linux-kernel-owner+w=401wt.eu-S1756519AbZJFPY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbZJFPY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755548AbZJFPY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:24:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60215 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700AbZJFPY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:24:56 -0400
Date: Tue, 6 Oct 2009 11:24:19 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org,
       lizf@cn.fujitsu.com
Subject: Re: [PATCH 2/3] perf trace: Update eval_flag() flags array to
	match interrupt.h
Message-ID: <20091006152419.GA10501@infradead.org>
References: <1254808849-7829-1-git-send-email-tzanussi@gmail.com> <1254808849-7829-3-git-send-email-tzanussi@gmail.com> <20091006132732.GA14978@infradead.org> <20091006151858.GB5152@nowhere> <20091006152106.GA6490@infradead.org> <20091006152255.GC5152@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006152255.GC5152@nowhere>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 05:22:58PM +0200, Frederic Weisbecker wrote:
> I see...
> Then the only solution I can imagine is to export a debugfs file
> in the tracing directory that provides this name resolution.

The format files kinda contain that information, just not in a very
useful format.  I think the general problem is that the formats exported
aren't descriptive enough, and fields/flags are just one symptom of
that.
