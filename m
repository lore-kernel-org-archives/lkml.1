Return-Path: <linux-kernel-owner+w=401wt.eu-S932709AbZJGLtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709AbZJGLtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 07:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932394AbZJGLte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 07:49:34 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:54131 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932376AbZJGLtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 07:49:33 -0400
Date: Wed, 7 Oct 2009 17:18:54 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: CGFreak control group visualizer
Message-ID: <20091007114854.GI6818@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <63386a3d0910061406p32e514cdjbe6059e7af60fb87@mail.gmail.com>
 <661de9470910061610n53bd0de0gdeb8dec854ef679a@mail.gmail.com>
 <63386a3d0910070403k1d1e6d56xa46d95d2ff448b2a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <63386a3d0910070403k1d1e6d56xa46d95d2ff448b2a@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.ml.walleij@gmail.com> [2009-10-07 13:03:30]:

> 2009/10/7 Balbir Singh <balbir@linux.vnet.ibm.com>:
> 
> > I looked at the screenshots and they look very interesting. Would it
> > take a lot of effort to extend it to track other controllers like
> > memory, network, etc?
> 
> No I don't think that'd be a problem if you can just come up with some
> proper visualization idea.
> 
> Memory can probably be a piechart as well, representing the physical memory
> (I think Matt already has some support for offline-generation of such charts in
> smem but this could be interactive, on-the-fly.)
>

Yeah.. that is a challenge, I tried running the visulation and it
seems to be quite heavy on the CPU and in my case with several
hundreds of process and several threads per process, the output
stopped making sense at some point. I'll play a bit more with it.
 
> Network bandwidth is harder I think because I don't know how these interfaces
> look if you want to measure throughput also (alottment would be easy to draw
> as a pie chart).
> 
> Patches welcome :-)a

:)

> 
> Linus Walleij

-- 
	Balbir
