Return-Path: <linux-kernel-owner+w=401wt.eu-S932690AbZGPQN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690AbZGPQN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 12:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932682AbZGPQN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 12:13:57 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:46361 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932681AbZGPQN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 12:13:56 -0400
Subject: Re: kmemleak reports
From: Catalin Marinas <catalin.marinas@arm.com>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247735505.24965.15.camel@pc1117.cambridge.arm.com>
References: <4A5D148A.5090405@gmail.com>
	 <1247735505.24965.15.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 16 Jul 2009 17:13:18 +0100
Message-Id: <1247760798.27689.19.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2009 16:13:19.0034 (UTC) FILETIME=[5527A9A0:01CA0630]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 10:11 +0100, Catalin Marinas wrote:
> On Tue, 2009-07-14 at 20:28 -0300, Kevin Winchester wrote:
> > However, I was thinking that you might soon start getting too many
> > reports to process.  I wonder if there might be some way that you
> > could have a similar facility to kerneloops that would automatically
> > register leak reports to a website where they could be organized and
> > ranked by number of occurrences.  Are the individual leaks reported in
> > such at way that would allow them to be grouped like that?
> 
> BTW, a step towards reducing the number of reports on the list is to
> maintain a tree based on the mainline which gathers various fixes posted
> by people. It is up to the maintainers to push them upstream but, in the
> meantime, people could try this tree and avoid reporting the same
> issues.

The first step - I created a branch for tracking the leak fixes posted
so far. This branch can be repeatedly merged (it is not rebased, or,
more exactly, it is rebased but benefits from the recent stgit publish
command to make rebasing invisible):

	git://linux-arm.org/linux-2.6 kmemleak-fixes

-- 
Catalin

