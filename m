Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbZHaGqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbZHaGqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 02:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbZHaGqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 02:46:52 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:60082 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbZHaGqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 02:46:51 -0400
Date: Mon, 31 Aug 2009 10:56:29 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Guillaume Chazarain <guichaz@gmail.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>, linux-kernel@vger.kernel.org,
       procps-feedback@lists.sf.net, Albert Cahalan <albert@users.sf.net>
Subject: Re: [PATCH 1/3] taskstats-fork: Add a new taskstats command to get
	notification on fork/clone
Message-ID: <20090831052629.GA16742@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <200907211031.48294.knikanth@suse.de> <20090721060114.GS24157@balbir.in.ibm.com> <200907211154.42563.knikanth@suse.de> <3d8471ca0908301252j15cb33b1j913921bd8fc6704c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <3d8471ca0908301252j15cb33b1j913921bd8fc6704c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Guillaume Chazarain <guichaz@gmail.com> [2009-08-30 21:52:22]:

> On Tue, Jul 21, 2009 at 8:24 AM, Nikanth Karthikesan<knikanth@suse.de> wrote:
> > Ah.. proc-events was the exact thing, I was looking for! Thanks.
> 
> AFAICT proc-events can only be used by root, so that makes it
> unsuitable for *top.
> 
> Anyway, iotop will always have to iterate over all threads to query
> their taskstats and other attributes, so the O(nr_threads) complexity
> is unavoidable.
>

Unless you want the stats for tgid in signal struct. In some cases we
accumulate, in some we don't. But yes irrespective or kernel/user
space the complexity exists. 

-- 
	Balbir
