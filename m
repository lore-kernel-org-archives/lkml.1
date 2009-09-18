Return-Path: <linux-kernel-owner+w=401wt.eu-S1751998AbZIRHpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbZIRHpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 03:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbZIRHpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 03:45:34 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44997 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbZIRHpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 03:45:33 -0400
Date: Fri, 18 Sep 2009 08:45:38 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Am?rico Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, William Irwin <wli@holomorphy.com>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Serge Hallyn <serue@us.ibm.com>, David Howells <dhowells@redhat.com>
Subject: Re: hugetlbfs warning in mmtom
Message-ID: <20090918074538.GC10106@csn.ul.ie>
References: <2375c9f90909172026o6095f0adx46df2bb05c46ff89@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <2375c9f90909172026o6095f0adx46df2bb05c46ff89@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 11:26:56AM +0800, Am?rico Wang wrote:
> It seems that this one is not reported yet.
> 
> Please feel free to ask more info from me if you need.
> 

This is a known problem. It's fixed by patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regionspatch-in-mm-fix.patch
which should appear in the next mmotm.

Thanks for the report.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
