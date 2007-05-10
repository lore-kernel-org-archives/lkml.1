Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbXEJH55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbXEJH55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 03:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbXEJH5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 03:57:50 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753182AbXEJH5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 03:57:49 -0400
Date: Thu, 10 May 2007 00:57:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: "Pallipadi\, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH -mm] timer: parenthesis fix in tbase_get_deferrable()
 etc.
Message-Id: <20070510005738.cebd2a40.akpm@linux-foundation.org>
In-Reply-To: <20070510073904.GB2021@ff.dom.local>
References: <653FFBB4508B9042B5D43DC9E18836F55DFC44@scsmsx415.amr.corp.intel.com>
	<20070510073904.GB2021@ff.dom.local>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 09:39:04 +0200 Jarek Poplawski <jarkao2@o2.pl> wrote:

> On 09-05-2007 21:10, Pallipadi, Venkatesh wrote:
> ...
> > On a 64 bit system, converting pointer to int causes unnecessary
> > compiler
> > warning, and intermediate long conversion was to avoid that. I will have
> > to rephrase my comment to remove 32 bit value and use int, as that is
> > what
> > the function returns.
> 
> Sorry!!! So, it's perfectly right and logical.
> 
> It's a pity, you couldn't NACK this patch a little sooner.
> I hope there is no problem to remove this patch now. 

Please send a new patch.  That way we get a nice explanation for the
reversion, and we have well-oiled processes for applying patches, but
crappy processes for reverting them.
