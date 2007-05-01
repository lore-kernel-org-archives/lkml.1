Return-Path: <linux-kernel-owner+w=401wt.eu-S1031142AbXEAI5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031142AbXEAI5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 04:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031601AbXEAI5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 04:57:55 -0400
Received: from 1wt.eu ([62.212.114.60]:2439 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031142AbXEAI5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 04:57:54 -0400
Date: Tue, 1 May 2007 10:57:10 +0200
From: Willy Tarreau <w@1wt.eu>
To: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-pcmcia@lists.infradead.org
Subject: Re: pcmcia ioctl removal
Message-ID: <20070501085710.GA13488@1wt.eu>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <20070501084623.GB14364@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070501084623.GB14364@infradead.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Tue, May 01, 2007 at 09:46:23AM +0100, Christoph Hellwig wrote:
> >  pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
> 
> ...
> 
> > Dominik is busy.  Will probably re-review and send these direct to Linus.
> 
> The patch above is the removal of cardmgr support.  While I'd love to
> see this cruft gone it definitively needs maintainer judgement on whether
> they time has come that no one relies on cardmgr anymore.

Well, I've not followed evolutions in this area for a long time. Here's
what I get on my notebook :

willy@wtap:~$ uname -r
2.6.20-wt3-wtap
willy@wtap:~$ ps auxw|grep card   
root      1216  0.0  0.0     0    0 ?        S<   Apr28   0:00 [pccardd]
root      1221  0.0  0.0     0    0 ?        S<   Apr28   0:00 [pccardd]
root      1244  0.0  0.0     0    0 ?        S<   Apr28   0:00 [pccardd]
root      1251  0.0  0.0     0    0 ?        Ss   Apr28   0:00 /sbin/cardmgr

What's the new recommended way of using PCMCIA cards when cardmgr is gone ?

Thanks,
Willy

