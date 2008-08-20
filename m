Return-Path: <linux-kernel-owner+w=401wt.eu-S1751574AbYHTELB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbYHTELB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 00:11:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbYHTEKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 00:10:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57018 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbYHTEKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 00:10:51 -0400
Date: Wed, 20 Aug 2008 06:12:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracehook: fix SA_NOCLDWAIT
Message-ID: <20080820041242.GS9807@one.firstfloor.org>
References: <20080819155722.GA25695@basil.nowhere.org> <20080820034229.43C7215449D@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080820034229.43C7215449D@magilla.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I outwitted myself again in commit 2b2a1ff64afbadac842bbc58c5166962cf4f7664,
> and broke the SA_NOCLDWAIT behavior so it leaks zombies.  This fixes it.
> 
> Reported-by: Andi Kleen <andi@firstfloor.org>

Confirmed -- this patch fixes the zombie problem on my box.

Tested-by: Andi Kleen <andi@firstfloor.org>

-Andi
