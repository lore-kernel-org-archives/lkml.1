Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbYF2NwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbYF2NwD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 09:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757074AbYF2Nvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 09:51:37 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:39259 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241AbYF2Nvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 09:51:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VEMxvf9iLC6jGMjUkA8KzJCvqTDy89wEA+xSiy07Hez3rBa/uT8jkyFGw8FkhEQq/S
         3DnDg3EQ7GbWWF7cHi8QMAkulJ44i4nMi1Falu0tFfAB59ak3vGnyBfb44Rd9rEA5oct
         Kmnhm8zVTwGKSXrnHxdiRp02fpc13BbUHtuo0=
Message-ID: <19f34abd0806290651g15d3048ejf41f0bd9f7ec1d4d@mail.gmail.com>
Date: Sun, 29 Jun 2008 15:51:33 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: -tip: WARNING: at kernel/lockdep.c:2738
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Steven Rostedt" <srostedt@redhat.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080629130554.GA16703@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0806290532k1b176d97k96f7c5bb2bb9e830@mail.gmail.com>
	 <20080629130554.GA16703@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2008 at 3:05 PM, Ingo Molnar <mingo@elte.hu> wrote:
> Does the patch below (or the tip/master i just pushed out) fix it?
>
>        Ingo
>
> ------------->
> commit 2d452c9b10caeec455eb5e56a0ef4ed485178213
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Sun Jun 29 15:01:59 2008 +0200

Yep, thanks, that gets rid of it for me! Although I'm not sure how
reproducible it was in the first place.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
