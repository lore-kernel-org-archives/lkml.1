Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbYELWgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbYELWgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 18:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbYELWgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 18:36:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34466
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754667AbYELWge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 18:36:34 -0400
Date: Mon, 12 May 2008 15:36:28 -0700 (PDT)
Message-Id: <20080512.153628.193699676.davem@davemloft.net>
To: mikpe@it.uu.se
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.26-rc1 lost half the RAM on UltraSPARC 5
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080512.153143.48741227.davem@davemloft.net>
References: <20080512.005036.19633770.davem@davemloft.net>
	<18472.38209.615770.265421@alkaid.it.uu.se>
	<20080512.153143.48741227.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 12 May 2008 15:31:43 -0700 (PDT)

> From: Mikael Pettersson <mikpe@it.uu.se>
> Date: Mon, 12 May 2008 21:06:41 +0200
> 
> > David Miller writes:
> >  > Please also add the debugging patch below.
> > 
> > Right, 2.6.26-rc2 plus your debugging patch and booted with numa=debug
> > prints the following:
> 
> Hmmm... my debugging patch had this:
> 
> diff --git a/lib/lmb.c b/lib/lmb.c
> index 83287d3..3f55973 100644
> --- a/lib/lmb.c
> +++ b/lib/lmb.c
>  ...
> +#define DEBUG
> +

Nevermind I see why the messages don't show up.  Hold on for a second
and I'll send an updated debugging patch.

Thanks.
