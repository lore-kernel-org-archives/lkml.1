Return-Path: <linux-kernel-owner+w=401wt.eu-S1763862AbYD3Vsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763862AbYD3Vsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758904AbYD3Vsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:48:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53358
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758372AbYD3Vsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:48:36 -0400
Date: Wed, 30 Apr 2008 14:48:35 -0700 (PDT)
Message-Id: <20080430.144835.25064746.davem@davemloft.net>
To: mingo@elte.hu
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] net: ipv6 build fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080430203839.GA19203@elte.hu>
References: <20080430.013138.157977693.davem@davemloft.net>
	<20080430203839.GA19203@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 30 Apr 2008 22:38:39 +0200

> 
> hi David,
> 
> * David Miller <davem@davemloft.net> wrote:
> 
> >       net: Several cleanups for the setsockopt compat support.
> >       net: Add compat support for getsockopt (MCAST_MSFILTER)
> 
> this broke !COMPAT builds in current -git. Fix below. NOTE: fix is just 
> a quick guess.

I know, Pavel posted a fix to netdev already which I'll push to
Linus.
