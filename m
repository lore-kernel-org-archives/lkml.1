Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbYJWHKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbYJWHKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 03:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYJWHKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 03:10:09 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52388 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbYJWHKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 03:10:07 -0400
Subject: Re: SLUB defrag pull request?
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: cl@linux-foundation.org, nickpiggin@yahoo.com.au, hugh@veritas.com,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <E1KsluU-0002R1-Ow@pomaz-ex.szeredi.hu>
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
	 <E1KsluU-0002R1-Ow@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 23 Oct 2008 10:10:31 +0300
Message-Id: <1224745831.25814.21.camel@penberg-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

﻿On Thu, 2008-10-23 at 00:10 +0200, Miklos Szeredi wrote:﻿
> Actually, no: looking at the slub code it already makes sure that
> objects are neither poisoned, nor touched in any way _if_ there is a
> constructor for the object. And for good reason too, otherwise a
> reused object would contain rubbish after a second allocation.

There's no inherent reason why we cannot poison slab caches with a
constructor. As a matter of fact SLAB does it which is probably why I
got confused here. The only thing that needs to disable slab poisoning
by design is SLAB_DESTROY_BY_RCU.

But for SLUB, you're obviously right.

﻿On Thu, 2008-10-23 at 00:10 +0200, Miklos Szeredi wrote:
> Come on guys, you should be the experts in this thing!

Yeah, I know. Yet you're stuck with us. That's sad.

		Pekka

