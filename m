Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbZIOXR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbZIOXR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 19:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbZIOXR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 19:17:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37338 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbZIOXRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 19:17:25 -0400
Date: Tue, 15 Sep 2009 19:17:24 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, paulus@samba.org,
       systemtap@sources.redhat.com
Subject: Re: [PATCH 2/2] tracing: Export ftrace API for kernel modules
Message-ID: <20090915231724.GA7636@infradead.org>
References: <4AAF6728.6010807@bk.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AAF6728.6010807@bk.jp.nec.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 07:06:32PM +0900, Atsushi Tsuji wrote:
> Export register_ and unresgister_ftrace_function_probe to modules. This can
> be used by SystemTap.

And can be added to the kernel treee once we merge a reasonably
rewritten version of it, if at all possible.

Remember that we do not add random crap for out of tree modules.
