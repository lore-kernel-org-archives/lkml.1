Return-Path: <linux-kernel-owner+w=401wt.eu-S933408AbZJFVnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408AbZJFVnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933338AbZJFVnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:43:09 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:60254 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933249AbZJFVnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:43:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ssalX5S2LExh74/gE6b02TPuwn2YoTVQ8mHrVqAWUTQw2DhcSGEy8Sqi8NpULE0Nxg
         m5y+z28T+cio8lZWrmeB4PhZFq//dRjZIKtV+WaM4zS8rWGlqLLDmXcNFqnnHKF7jv3R
         1xtlNdPiTCwwCoZIlUWLf+VkKr+HNPFI088xQ=
Date: Tue, 6 Oct 2009 23:42:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rostedt@goodmis.org, lizf@cn.fujitsu.com
Subject: Re: [PATCH 2/3] perf trace: Update eval_flag() flags array to
	match interrupt.h
Message-ID: <20091006214228.GB5343@nowhere>
References: <1254808849-7829-1-git-send-email-tzanussi@gmail.com> <1254808849-7829-3-git-send-email-tzanussi@gmail.com> <20091006132732.GA14978@infradead.org> <20091006151858.GB5152@nowhere> <20091006152106.GA6490@infradead.org> <20091006152255.GC5152@nowhere> <20091006152419.GA10501@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006152419.GA10501@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 11:24:19AM -0400, Christoph Hellwig wrote:
> On Tue, Oct 06, 2009 at 05:22:58PM +0200, Frederic Weisbecker wrote:
> > I see...
> > Then the only solution I can imagine is to export a debugfs file
> > in the tracing directory that provides this name resolution.
> 
> The format files kinda contain that information, just not in a very
> useful format.  I think the general problem is that the formats exported
> aren't descriptive enough, and fields/flags are just one symptom of
> that.


Well, Steve has posted a whole rewrite of the format files some months ago,
I don't know what's the status of this work. One of the problems is that we
know have tools that support the current format.

