Return-Path: <linux-kernel-owner+w=401wt.eu-S1760016AbXEJJ3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016AbXEJJ3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 05:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756514AbXEJJ32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 05:29:28 -0400
Received: from mx12.go2.pl ([193.17.41.142]:37264 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754881AbXEJJ31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 05:29:27 -0400
Date: Thu, 10 May 2007 11:35:49 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Pallipadi\, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] timer: revert parenthesis fix in tbase_get_deferrable() etc.
Message-ID: <20070510093549.GB2741@ff.dom.local>
References: <653FFBB4508B9042B5D43DC9E18836F55DFC44@scsmsx415.amr.corp.intel.com> <20070510073904.GB2021@ff.dom.local> <20070510005738.cebd2a40.akpm@linux-foundation.org> <20070510092947.GA2741@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510092947.GA2741@ff.dom.local>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 11:29:47AM +0200, Jarek Poplawski wrote:
...
> [PATCH] timer: revert parenthesis fix in tbase_get_deferrable() etc.
> 
> > > On 09-05-2007 21:10, Pallipadi, Venkatesh wrote:
> > > ...
> > > > On a 64 bit system, converting pointer to int causes unnecessary
> > > > compiler
> > > > warning, and intermediate long conversion was to avoid that. I will have
> > > > to rephrase my comment to remove 32 bit value and use int, as that is
> > > > what
> > > > the function returns.
> 
> So, this patch reverts all changes done by my previous patch.
> 
> I appologize for my wrong comment about "logical error" here.

Should be:

I apologize for my wrong comment about "logical error" here.

Jarek P.

PS: Why I couldn't be sorry, as usual...
