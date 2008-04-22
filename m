Return-Path: <linux-kernel-owner+w=401wt.eu-S1762586AbYDVK1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762586AbYDVK1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 06:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbYDVK1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 06:27:04 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:3152
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757808AbYDVK1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 06:27:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhUBAI5aDUh8qMUd/2dsb2JhbAAIrBw
X-IronPort-AV: E=Sophos;i="4.25,693,1199631600"; 
   d="scan'208";a="305326064"
Subject: Re: [PATCH 3/3] UIO: generic platform driver
From: Ben Nizette <bn@niasdigital.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1208857977-29493-3-git-send-email-Uwe.Kleine-Koenig@digi.com>
References: <20080422094708.GB27126@digi.com>
	 <1208857977-29493-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
	 <1208857977-29493-2-git-send-email-Uwe.Kleine-Koenig@digi.com>
	 <1208857977-29493-3-git-send-email-Uwe.Kleine-Koenig@digi.com>
Content-Type: text/plain; charset=utf-8
Organization: Nias Digital
Date: Tue, 22 Apr 2008 20:26:57 +1000
Message-Id: <1208860018.4620.100.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-22 at 11:52 +0200, Uwe Kleine-König wrote:
> Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> ---
> Hello,
> 
> This is the former patch 4/4 after some discussion.
> 
> Open issues:
>   - clock name "uio" isn't considered good by Russell King
>     I don't have a better suggestion

I'd suggest it should be passed through from the platform code: only it
knows what it's going to be (and if indeed there's going to be one at
all).  In fact, the lack-of-clock at the moment is fatal; it shouldn't
be IMO.  For example, I don't need one in SMX.

>   - some code could be shared with uio_smx.c
>     I would address that in a seperate patch after this one hits mainline.

As I said before I'd prefer to keep my driver separate and standalone,
but you and HJK have expressed a wish for unification.  If I get this
formally I'll consider myself outvoted and submit a patch to unify it
all when I submit my platform code (soon).

	--Ben.
