Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbYH1MSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbYH1MSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 08:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbYH1MSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 08:18:22 -0400
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:35058 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751828AbYH1MSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 08:18:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nIhzfv/4FkaVT44Zl9XqzDNBa9eq/ynTywl08Ol72mGERPF7w+1BOc89W4bxrNVpExTqMFNbgwuj+XJP2w+NdNLOr/hVwmGRghOfp4Aydw+fAmlqF+v4l/taBCiiV+FzN0FO+ARNGGXhe51L3IZougeVeE4nNvrmuPfnczNAjDk=  ;
X-YMail-OSG: xGwikyoVM1mSt_OLf2ZTcQ9KiSvpEklrmmrvytCg4qWZjVEKGjczlbtw6fB6VheIqNdC0hx6kq9JA1fmP8llF5pJo39Z_G6Yweme2WFFKxv1tvXrciNEnybWCdMQn4FMRl4-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Date: Thu, 28 Aug 2008 22:18:14 +1000
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080819103301.787700742@chello.nl> <1219924853.6443.18.camel@twins> <20080828121436.GN26610@one.firstfloor.org>
In-Reply-To: <20080828121436.GN26610@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808282218.14469.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 August 2008 22:14, Andi Kleen wrote:
> > Then people can no longer assume stuff like queue_work_on() etc.. works.
> > Users of such code might depend on it actually running on the specified
> > cpu.
>
> If they assume that they're already buggy because CPU hot unplug will break
> affinities.

It is actually possible (with fairly little work, last time I looked,
maybe it is already integrated in the kernel) to avoid all this kind of
thing from isolated CPUs.

But even then, note that the types of programs using the CPU for long
periods are obviously not going to be run on an average desktop system.
So the responsiveness argument is laughable. Responsive as defined how?
And in relation to what type of systems?
