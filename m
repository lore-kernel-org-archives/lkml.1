Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbZG0Up4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbZG0Up4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 16:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbZG0Upz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 16:45:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754595AbZG0Upz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 16:45:55 -0400
Date: Mon, 27 Jul 2009 13:45:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ray Lee <ray-lk@madrabbit.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
In-Reply-To: <87ocr5dfpb.fsf@devron.myhome.or.jp>
Message-ID: <alpine.LFD.2.01.0907271343240.25224@localhost.localdomain>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk> <87bpn7mzli.fsf@devron.myhome.or.jp> <20090727115723.1e8de60e@lxorguk.ukuu.org.uk> <873a8iqqgv.fsf@devron.myhome.or.jp> <20090727142303.41096bf5@lxorguk.ukuu.org.uk> <877hxujkuv.fsf@devron.myhome.or.jp>
 <20090727145805.690afe5d@lxorguk.ukuu.org.uk> <87fxci6ub9.fsf@devron.myhome.or.jp> <20090727161424.GA4233@skywalker> <20090727174252.2d987830@lxorguk.ukuu.org.uk> <20090727171213.GB4233@skywalker> <87skgikjr8.fsf@devron.myhome.or.jp>
 <alpine.LFD.2.01.0907271237250.25224@localhost.localdomain> <87ocr5dfpb.fsf@devron.myhome.or.jp>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 28 Jul 2009, OGAWA Hirofumi wrote:
> 
> > So at what point do we just admit that the commit that caused all this was 
> > a buggy pile of sh*t and just revert it?
> 
> Also, I'm not sure though, I guess it depends on the bug which was fixed
> by the commit.

It doesn't really.

The fact is, we don't accept "fix one bug, introduce another" code. We're 
much better off with _old_ bugs than with new ones.

I'd love to have both the old and the new fixed, but I'm not seeing a lot 
of progress on this new bug, and at some point I'm going to have to decide 
to just revert the commit that caused this whole breakage, until a fix 
that doesn't cause new problems can be worked out.

			Linus
