Return-Path: <linux-kernel-owner+w=401wt.eu-S935202AbYEBWAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935202AbYEBWAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 18:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846AbYEBWAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 18:00:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43592
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755023AbYEBWAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 18:00:02 -0400
Date: Fri, 02 May 2008 15:00:01 -0700 (PDT)
Message-Id: <20080502.150001.132956068.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: guichaz@gmail.com, efault@gmx.de, elendil@planet.nl,
       parag.warudkar@gmail.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
Subject: Re: 'global' rq->clock
From: David Miller <davem@davemloft.net>
In-Reply-To: <1209761165.6929.25.camel@lappy>
References: <1209758186.6929.18.camel@lappy>
	<3d8471ca0805021338x7cde7d1fwbbb58a6c65a1349d@mail.gmail.com>
	<1209761165.6929.25.camel@lappy>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 02 May 2008 22:46:05 +0200

> We can toss most of this code on archs like power64, sparc64 and s390x
> which have stable clocks. It just seems wrong to do all this on these
> archs, but don't have much choice on x86.

All of this scheduler runqueue clock business is probably solving
the x86 TSC issue on the wrong level.

I suggest having a char with Andi Kleen about these issues, he's
had some good ideas in the past which were ignored for whatever
reasons...
