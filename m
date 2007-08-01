Return-Path: <linux-kernel-owner+w=401wt.eu-S1761774AbXHAKhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761774AbXHAKhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 06:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761446AbXHAKhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 06:37:07 -0400
Received: from mx1.suse.de ([195.135.220.2]:59034 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760460AbXHAKhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 06:37:05 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       CK Mailinglist <ck@vds.kolivas.org>, teresa@kvitka.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux Kernel cfs scheduler and xorg kbd
References: <1185827130.26459.16.camel@xtower.fri>
	<6bffcb0e0707301549t6be3cd97y27726f5421bb7680@mail.gmail.com>
	<20070801064816.GC10134@elte.hu>
From: Andi Kleen <andi@firstfloor.org>
Date: 01 Aug 2007 13:31:39 +0200
In-Reply-To: <20070801064816.GC10134@elte.hu>
Message-ID: <p73abtbpk2s.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
> 
> another reaction below in this thread reported kbd problems in vanilla 
> 2.6.22.1 as well. What is the X versions, etc.? Does the problem go away 
> if the X kbd driver selection is tweaked to a simpler model, say:

Or perhaps just test with CFS reverted? It really sounds more like something
independent from the scheduler. Perhaps someone could put a CFS-revert-for-testing patch
on ftp somewhere. It's only a few git changesets so shouldn't be too difficult to
do.

-Andi
