Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbYBINns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbYBINns (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 08:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbYBINnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 08:43:40 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33197 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367AbYBINnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 08:43:39 -0500
Date: Sat, 9 Feb 2008 15:18:52 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Prakash Punnoor <prakash@punnoor.de>, Andi Kleen <andi@firstfloor.org>,
       mingo@elte.hu, tglx@linutronix.de, lenb@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace nvidia timer override quirk with pci id list
Message-ID: <20080209141852.GC22569@one.firstfloor.org>
References: <20080207195519.GA21772@basil.nowhere.org> <20080208160906.GA9642@one.firstfloor.org> <200802081839.18267.prakash@punnoor.de> <200802090746.25310.gene.heskett@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802090746.25310.gene.heskett@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sort of coming in in the middle of this because I just realized this may have 
> something to do with the "exception Emask" errors. I have an NF2, and the 

exception Emask is a SATA problem. Shouldn't be caused by timer troubles.
This means in theory it could be that your sata driver if compiled
in is the first thing to use timers, but normally if the timers are
broken you get a earlier hang somewhere else.

-Andi

