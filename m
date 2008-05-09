Return-Path: <linux-kernel-owner+w=401wt.eu-S1759724AbYEINJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759724AbYEINJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 09:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757613AbYEINI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 09:08:58 -0400
Received: from pxy2nd.nifty.com ([202.248.175.14]:35160 "HELO pxy2nd.nifty.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755730AbYEINI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 09:08:57 -0400
X-Nifty-SrcIP: [210.170.193.31]
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=pxy2nd-default; d=mbf.nifty.com;
  b=gifQPvJn/UlPn9uRRmJd4y439pTn3NJI0B1T5C3537DORS1/XNYZg/gWl6kz+zbNFisaU23XRQOjyTyH0Z1YFQ==  ;
Date: Fri, 09 May 2008 21:56:01 +0900 (JST)
Message-Id: <20080509.215601.208967867.takada@mbf.nifty.com>
To: bzolnier@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: kernel 2.6.25 with ide driver cs5520 does not boot.
From: TAKADA Yoshihito <takada@mbf.nifty.com>
In-Reply-To: <200805091127.53737.bzolnier@gmail.com>
References: <58cb370e0805080607n4f5de192o5a7371fd0fb1e9f8@mail.gmail.com>
	<20080509.112220.74748072.takada@mbf.nifty.com>
	<200805091127.53737.bzolnier@gmail.com>
X-Mailer: Mew version 6.0.50 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: kernel 2.6.25 with ide driver cs5520 does not boot.
Date: Fri, 9 May 2008 11:27:53 +0200

> On Friday 09 May 2008, TAKADA Yoshihito wrote:
> > Thanks for quick reply.
> > 
> > I tried 2.6.26rc1. It hangs same as 2.6.25.
> > kernel 2.6.26rc1 with cs5520 cannot boot. cs5520 scans ide0 and ide1.
> > It seems 2nd port DMA base issue was solved.
> 
> [...]
> 
> Thanks.
> 
> The following patch for 2.6.26-rc1 disables VDMA, please give it a try
> (I haven't time to fully audit VDMA support yet but lets see if it is
> the main source of the problems).

I applied the patch. But kernel was hung.
And I attempt to kill IDE_HFLAG_CS5520. It cannot boot, oo.

  kill IDE_HFLAG_VDMA  : hang  
  kill IDE_HFLAG_CS5520: hang
  kill both flags      : boot



