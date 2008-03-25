Return-Path: <linux-kernel-owner+w=401wt.eu-S1759797AbYCYUuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759797AbYCYUuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 16:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbYCYUur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 16:50:47 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:60679 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbYCYUuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 16:50:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cIxl20OImnTeKcSN+Jk5yy/3mNXBglAiNOTp4NdJRacrEWylAVWXgNOHy3FGnZpNDleSN21VpqTfZQi5kR29Y3MncLuuL/i882KDnXkwLymMYXkyIBqypqE7T5lfyq90/z34J7kLCqHE3puuwbPlRJl9GqL/5ijeMi+QYm91q+U=
Message-ID: <998d0e4a0803251350x6e18a250k3f8bd559c762d9f1@mail.gmail.com>
Date: Tue, 25 Mar 2008 21:50:37 +0100
From: "J.C. Pizarro" <jcpiza@gmail.com>
To: "Ray Lee" <ray-lk@madrabbit.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Poor performance now? Please, put weighted velocities ctxts/s to the sched.decision!
In-Reply-To: <2c0942db0803251338n47dba8e5l1364b30adbf415be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <998d0e4a0803251329o4dabd28ck5197838fe6920441@mail.gmail.com>
	 <2c0942db0803251338n47dba8e5l1364b30adbf415be@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008/3/25, Ray Lee <ray-lk@madrabbit.org> wrote:
> On Tue, Mar 25, 2008 at 1:29 PM, J.C. Pizarro <jcpiza@gmail.com> wrote:
>  >  [2] "Re: Serious performance regression in Wine applications and Linux 2.6.24.*"
>  >  http://lkml.org/lkml/2008/3/25/181
>  >  On Tue, 25 Mar 2008 08:49:13 -0700, "Ray Lee" wrote:
>  >  > Andi's idea of looking for excessive context switches is good -- I
>  >  > didn't see a response to that one. Other than that, if you're only
>  >  > noticing the issue in 3d games, then it could be several things (not
>  >  > just the scheduler).
>  >
>  >  The kernel needed the velocity parameter to gain it: ctxts per interval
>  >  (normally ctxts/s or ctxts/minute).
>
>
> We don't know that's the problem yet. The reporter is doing more testing.
>
>
>  >  "Please, put 64-bit counter per task and incr.by.one each ctxt switch."
>  >  http://lkml.org/lkml/2008/2/23/398
>  >  http://lkml.org/lkml/2008/2/23/401
>  >  http://lkml.org/lkml/2008/2/23/406
>  >  http://lkml.org/lkml/2008/2/24/1
>  >  http://lkml.org/lkml/2008/2/24/103
>  >  http://lkml.org/lkml/2008/2/24/157
>  >  http://lkml.org/lkml/2008/2/26/159
>
>
> There are already counters recording the switches:
>     http://lkml.org/lkml/2008/2/25/314

I forgot this link, thanks!

It seems that they don't make ++ of counters in each switch ocurr.
I don't know how they record the switches.

The current scheduler don't take the count or the velocity of ctxts
as an extra parameter more in the decision of scheduling.

>  >  My proposal is free for yours, quasi-bastards, I won't charge you!
>
>
> My parents were married.

Luck boy ;) !
