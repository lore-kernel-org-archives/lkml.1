Return-Path: <linux-kernel-owner+w=401wt.eu-S1752616AbYJWIkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbYJWIkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 04:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbYJWIj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 04:39:26 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49838 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbYJWIjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 04:39:23 -0400
To: penberg@cs.helsinki.fi
CC: miklos@szeredi.hu, cl@linux-foundation.org, nickpiggin@yahoo.com.au,
       hugh@veritas.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-reply-to: <1224745831.25814.21.camel@penberg-laptop> (message from Pekka
	Enberg on Thu, 23 Oct 2008 10:10:31 +0300)
Subject: Re: SLUB defrag pull request?
References: <1223883004.31587.15.camel@penberg-laptop>
	 <E1Ks1hu-0002nN-9f@pomaz-ex.szeredi.hu>
	 <48FE6306.6020806@linux-foundation.org>
	 <E1KsXrY-0000AU-C4@pomaz-ex.szeredi.hu>
	 <Pine.LNX.4.64.0810220822500.30851@quilx.com>
	 <E1Ksjed-00023D-UB@pomaz-ex.szeredi.hu>
	 <Pine.LNX.4.64.0810221252570.3562@quilx.com>
	 <E1Ksk3g-00027r-Lp@pomaz-ex.szeredi.hu>
	 <Pine.LNX.4.64.0810221315080.26671@quilx.com>
	 <E1KskHI-0002AF-Hz@pomaz-ex.szeredi.hu>
	 <84144f020810221348j536f0d84vca039ff32676e2cc@mail.gmail.com>
	 <E1Ksksa-0002Iq-EV@pomaz-ex.szeredi.hu>
	 <Pine.LNX.4.64.0810221416130.26639@quilx.com>
	 <E1KsluU-0002R1-Ow@pomaz-ex.szeredi.hu> <1224745831.25814.21.camel@penberg-laptop>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1KsviY-0003Mq-6M@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 23 Oct 2008 10:38:54 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2008, Pekka Enberg wrote:
> ﻿On Thu, 2008-10-23 at 00:10 +0200, Miklos Szeredi wrote:﻿
> > Actually, no: looking at the slub code it already makes sure that
> > objects are neither poisoned, nor touched in any way _if_ there is a
> > constructor for the object. And for good reason too, otherwise a
> > reused object would contain rubbish after a second allocation.
> 
> There's no inherent reason why we cannot poison slab caches with a
> constructor.

Right, it just needs to call the constructor for every allocation.

> > Come on guys, you should be the experts in this thing!
> 
> Yeah, I know. Yet you're stuck with us. That's sad.

No, I was a bit rude, sorry.

I think the _real_ problem is that instead of fancy features like this
defragmenter, SLUB should first concentrate on getting the code solid
enough to replace the other allocators.

Miklos
