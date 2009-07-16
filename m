Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbZGPJL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbZGPJL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 05:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbZGPJL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 05:11:56 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:48993 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754275AbZGPJLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 05:11:55 -0400
Subject: Re: kmemleak reports
From: Catalin Marinas <catalin.marinas@arm.com>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A5D148A.5090405@gmail.com>
References: <4A5D148A.5090405@gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 16 Jul 2009 10:11:45 +0100
Message-Id: <1247735505.24965.15.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2009 09:11:47.0012 (UTC) FILETIME=[71EF6040:01CA05F5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-14 at 20:28 -0300, Kevin Winchester wrote:
> However, I was thinking that you might soon start getting too many
> reports to process.  I wonder if there might be some way that you
> could have a similar facility to kerneloops that would automatically
> register leak reports to a website where they could be organized and
> ranked by number of occurrences.  Are the individual leaks reported in
> such at way that would allow them to be grouped like that?

BTW, a step towards reducing the number of reports on the list is to
maintain a tree based on the mainline which gathers various fixes posted
by people. It is up to the maintainers to push them upstream but, in the
meantime, people could try this tree and avoid reporting the same
issues.

I'll try to set this up, ideally on kernel.org for wider visibility (if
I manage to get an account, otherwise on linux-arm.org/git where I
usually keep my trees).

-- 
Catalin

