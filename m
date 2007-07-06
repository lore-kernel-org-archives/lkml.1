Return-Path: <linux-kernel-owner+w=401wt.eu-S1762919AbXGFOMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762919AbXGFOMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 10:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbXGFOMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 10:12:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:3225 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbXGFOMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 10:12:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=T1CxlUyICCS1UegF2Rznut28ZfmVxn1jFl461Z3tMz/8NcwGrctjtdd4fxbay0N8G6ZYl06i97eOfceMp9GInTUm2km1/VM6d7z1sEaylxmC3dS5yK36xUlIzrUF1fJsdojAc2ZuJ+gbBxmijJRAHEh515GldayJqpXrIQBvTC4=
Date: Fri, 6 Jul 2007 18:11:56 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vincent Hanquez <tab@snarc.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminge <shemminger@linux-foundation.org>
Subject: Re: [PATCH] Sky Cpu: use C99 style for struct init
Message-ID: <20070706141156.GB7179@cvg>
References: <20070705175910.GG7180@cvg> <20070706092100.GA11667@snarc.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070706092100.GA11667@snarc.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Vincent Hanquez - Fri, Jul 06, 2007 at 11:21:00AM +0200]
| On Thu, Jul 05, 2007 at 09:59:10PM +0400, Cyrill Gorcunov wrote:
| > +      .fasync	= NULL,
| > +      .poll	= NULL,
| > +      .ioctl	= NULL,
| 
| you can remove those since C99 automaticly initialize missing fields to 0.
| 
| Cheers,
| -- 
| Vincent Hanquez
| 

ok, thanks
		Cyrill

