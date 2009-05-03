Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbZECQQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbZECQQw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 12:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756030AbZECQQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 12:16:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35290 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754863AbZECQQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 12:16:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/4] PM/Hibernate: Use memory allocations to free memory (rev. 2)
Date: Sun, 3 May 2009 18:15:32 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, pavel@ucw.cz,
       jens.axboe@oracle.com, alan-jenkins@tuffmail.co.uk,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905030224.21471.rjw@sisk.pl> <alpine.LFD.2.01.0905021958480.4983@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0905021958480.4983@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905031815.33455.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 May 2009, Linus Torvalds wrote:
> 
> On Sun, 3 May 2009, Rafael J. Wysocki wrote:
> >
> > Remove the shrinking of memory from the suspend-to-RAM code, where it is 
> > not really necessary.
> 
> Hmm. Shouldn't we do this _regardless_?
> 
> IOW, shouldn't this be a totally separate patch? It seems to be left-over 
> from when we shared the same code-paths, and before the split of the STR 
> and hibernate code?
> 
> IOW, shouldn't the very _first_ patch just be this part? That code doesn't 
> make any sense anyway (that FREE_PAGE_NUMBER really _is_ totally 
> arbitrary).
> 
> This part seems to be totally independent of all the other parts in your 
> patch-series. No?

I'm removing this along with shrink_all_memory() which it depends on, but I can
put that into a separate patch if you prefer.

Thanks,
Rafael
