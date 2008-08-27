Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbYH0Otq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbYH0Otq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755483AbYH0Oti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 10:49:38 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:54062 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647AbYH0Oth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 10:49:37 -0400
Subject: Re: An idea .... with code
From: Kasper Sandberg <lkml@metanurb.dk>
To: Andi Kleen <andi@firstfloor.org>
Cc: jassi brar <jassi_singh_brar@yahoo.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080827124734.GT26610@one.firstfloor.org>
References: <20080827074751.GO26610@one.firstfloor.org>
	 <35042.98883.qm@web33207.mail.mud.yahoo.com>
	 <20080827124734.GT26610@one.firstfloor.org>
Content-Type: text/plain
Date: Wed, 27 Aug 2008 16:49:35 +0200
Message-Id: <1219848575.9776.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-27 at 14:47 +0200, Andi Kleen wrote:
> >  As far as features are concerned, please suggest me what could be done with /dev/loop0 and not for /dev/vblk?
> 
> Serious question?  cryptoloop, offsets are the big ticket items,
> i'm sure there are more.

As far as cryptoloop goes, isnt that obsoleted anyway? is there anyone
that doesent use dm-crypt by now?

as for offsets, isnt this a logical thing to do with devicemapper
aswell?

ofcourse loop/losetup cannot just be removed, theres probably LOTS of
scripts around which are being used.

> 
> -Andi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

