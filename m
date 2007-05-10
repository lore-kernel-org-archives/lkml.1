Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbXEJHcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbXEJHcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 03:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758564AbXEJHcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 03:32:43 -0400
Received: from mx2.go2.pl ([193.17.41.42]:46454 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758630AbXEJHcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 03:32:42 -0400
Date: Thu, 10 May 2007 09:39:04 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: "Pallipadi\, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH -mm] timer: parenthesis fix in tbase_get_deferrable() etc.
Message-ID: <20070510073904.GB2021@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <653FFBB4508B9042B5D43DC9E18836F55DFC44@scsmsx415.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-05-2007 21:10, Pallipadi, Venkatesh wrote:
...
> On a 64 bit system, converting pointer to int causes unnecessary
> compiler
> warning, and intermediate long conversion was to avoid that. I will have
> to rephrase my comment to remove 32 bit value and use int, as that is
> what
> the function returns.

Sorry!!! So, it's perfectly right and logical.

It's a pity, you couldn't NACK this patch a little sooner.
I hope there is no problem to remove this patch now. 

It seems this type of conversion isn't popular enough, yet.

Thanks for explanation & regards,
Jarek P.
