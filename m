Return-Path: <linux-kernel-owner+w=401wt.eu-S1757479AbZJFPIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbZJFPIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757316AbZJFPIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:08:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49410 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756453AbZJFPIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:08:30 -0400
Date: Tue, 6 Oct 2009 11:07:51 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Soeren Sandmann <sandmann@daimi.au.dk>
Cc: gnome-announce@gnome.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: Announce: Sysprof 1.1.2 CPU profiler for Linux
Message-ID: <20091006150751.GA28868@infradead.org>
References: <ye8bpkxemk0.fsf@camel21.daimi.au.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ye8bpkxemk0.fsf@camel21.daimi.au.dk>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 26, 2009 at 05:46:23PM +0200, Soeren Sandmann wrote:
> Sysprof 1.1.2 is now available. This is a development release leading
> up to a stable 1.2.0 release.
> 
> Sysprof is a sampling system-wide CPU profiler for Linux.  This
> version is based on the perf counter interface in 2.6.31 kernels and
> will not work with earlier kernels.

Btw, what is the plan for the sysprof ftrace plugin?  In general we move
away from ftrace plugins towards trace events and perf, and if I
remember correctly ftrace file format changes caused enough pain for
sysprof that it kept shipping it's old hacky kernel module.

Is it time to deprectate the sysprof ftrace plugin?

