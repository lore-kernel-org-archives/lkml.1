Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411AbZIRIkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbZIRIkE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 04:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbZIRIkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 04:40:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741AbZIRIkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 04:40:00 -0400
Date: Fri, 18 Sep 2009 01:38:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Am?rico Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>, Serge Hallyn <serue@us.ibm.com>,
       David Howells <dhowells@redhat.com>,
       Eric B Munson <ebmunson@us.ibm.com>
Subject: Re: hugetlbfs warning in mmtom
Message-Id: <20090918013843.5704a634.akpm@linux-foundation.org>
In-Reply-To: <20090918074538.GC10106@csn.ul.ie>
References: <2375c9f90909172026o6095f0adx46df2bb05c46ff89@mail.gmail.com>
	<20090918074538.GC10106@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009 08:45:38 +0100 Mel Gorman <mel@csn.ul.ie> wrote:

> On Fri, Sep 18, 2009 at 11:26:56AM +0800, Am?rico Wang wrote:
> > It seems that this one is not reported yet.
> > 
> > Please feel free to ask more info from me if you need.
> > 
> 
> This is a known problem. It's fixed by patch
> hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regionspatch-in-mm-fix.patch
> which should appear in the next mmotm.
> 

Actually I tempdropped
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
and its fixes because alpha broke, mips broke and I didn't feel like
running around working out which other architectures got broken.

