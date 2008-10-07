Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbYJGBdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbYJGBdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbYJGBdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 21:33:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:34190 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbYJGBdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 21:33:07 -0400
Message-ID: <48EABBD3.1010401@kernel.org>
Date: Tue, 07 Oct 2008 10:30:59 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: avorontsov@ru.mvista.com
CC: Matt Sealey <matt@genesi-usa.com>, Jeff Garzik <jgarzik@pobox.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Li Yang <leoli@freescale.com>,
       Wang Jian <lark@linux.net.cn>
Subject: Re: [PATCH] pata_of_platform: fix no irq handling
References: <20081006172653.GA26427@oksana.dev.rtsoft.ru> <48EA77EF.6080502@genesi-usa.com> <20081006213209.GA13072@oksana.dev.rtsoft.ru>
In-Reply-To: <20081006213209.GA13072@oksana.dev.rtsoft.ru>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Oct 2008 01:32:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov wrote:
> On Mon, Oct 06, 2008 at 03:41:19PM -0500, Matt Sealey wrote:
>> There is a simple problem with the patch which is that an "IRQ 0" can and does
>> actually exist on a bunch of platforms, at least to the best of my knowledge.
>>
>> Checking for -1 (which means for definite, no irq at all, because it is
>> totally unambiguous, as a -1 IRQ numbering is "impossible") is more correct.
> 
> This was discussed years ago.
> 
> http://lkml.org/lkml/2005/11/22/159
> http://lkml.org/lkml/2005/11/22/227
> 

Would this break any existing platforms?  If so, can those be fixed
together or does it become a much bigger problem that way?

Thanks.

-- 
tejun
