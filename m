Return-Path: <linux-kernel-owner+w=401wt.eu-S1762076AbYFMJcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762076AbYFMJcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 05:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756317AbYFMJcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 05:32:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55531
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755520AbYFMJcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 05:32:08 -0400
Date: Fri, 13 Jun 2008 02:32:08 -0700 (PDT)
Message-Id: <20080613.023208.78649628.davem@davemloft.net>
To: mingo@elte.hu
Cc: kuznet@ms2.inr.ac.ru, vgusev@openvz.org, mcmanus@ducksong.com,
       xemul@openvz.org, netdev@vger.kernel.org, ilpo.jarvinen@helsinki.fi,
       linux-kernel@vger.kernel.org
Subject: Re: [TCP]: TCP_DEFER_ACCEPT causes leak sockets
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080613063037.GA16943@elte.hu>
References: <20080611.165255.242691774.davem@davemloft.net>
	<20080612.163212.148965080.davem@davemloft.net>
	<20080613063037.GA16943@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 13 Jun 2008 08:30:37 +0200

> the 3 reverts have been extensively tested in -tip via:
> 
>  # tip/out-of-tree: 9e5b6ca: tcp: revert DEFER_ACCEPT modifications
> 
> and the distcc problems are fixed. (The locking fix alone did not fix it 
> conclusively in my testing, possibly due to the follow-on observations 
> outlined in your description.)
> 
> Tested-by: Ingo Molnar <mingo@elte.hu>

I didn't revert all three changes, just the final part of that
3 part series.

Please test the patch I actually applied.
