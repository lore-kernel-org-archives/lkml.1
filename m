Return-Path: <linux-kernel-owner+w=401wt.eu-S1762522AbXIKRVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762522AbXIKRVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 13:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759514AbXIKRVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 13:21:39 -0400
Received: from ns2.suse.de ([195.135.220.15]:33846 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759306AbXIKRVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 13:21:38 -0400
Date: Tue, 11 Sep 2007 19:21:37 +0200
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [patch 1/5] Extended crashkernel command line
Message-ID: <20070911172137.GF20907@suse.de>
Mail-Followup-To: kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20070909083914.065380136@strauss.suse.de> <20070909083914.488571169@strauss.suse.de> <20070911131445.GA17460@suse.de> <20070911153209.GA5054@nlxdcldnl2.cl.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070911153209.GA5054@nlxdcldnl2.cl.intel.com>
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Lombard, David N <dnlombar@ichips.intel.com> [2007-09-11 17:32]:
> 
> lilo:
>   append=<string>
> 
>     Appends the options specified to the parameter line passed to
>     the kernel. 

Given that lilo appends the user-specified command line, I think it's
the best to honor the last value. It has also been the previous
behaviour (execpt IA64).

Having a different behaviour if the last or the first value is honored
on different architectures is not what we want, IMO.


Thanks,
   Bernhard
