Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbZLINzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbZLINzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 08:55:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755989AbZLINzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 08:55:10 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:49954 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987AbZLINzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 08:55:09 -0500
Message-ID: <4B1FABFB.8090107@gmail.com>
Date: Wed, 09 Dec 2009 14:54:03 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] kmemcheck: make bitfield annotations truly no-ops when
 disabled
References: <1260121333-19642-1-git-send-email-vegard.nossum@gmail.com> <20091207141356.9e83fd5b.akpm@linux-foundation.org> <4B1FA6B6.8070701@cs.helsinki.fi>
In-Reply-To: <4B1FA6B6.8070701@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 09 Dec 2009 14:54:05 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 09/12/2009 14:31, Pekka Enberg a écrit :

> 
> I guess so. Eric, how bad is the regression?
> 

Not too bad, skbuff one was separately addressed.

http://git2.kernel.org/?p=linux/kernel/git/davem/net-next-2.6.git;a=commitdiff;h=14d18a81b5171d4433e41129619c75748b4f4d26
