Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbYLKH5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbYLKH5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 02:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbYLKH5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 02:57:43 -0500
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:29245 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751054AbYLKH5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 02:57:43 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=zy0A5DBDeMzOB+BJSqYUIQnZIXkl+gb5AYLON5d/ii3eyLuuH32SXN4K3Js8+faHXCnvxEK6tWUqN+gz4AvysB0Q2HRm/oSaXtxQOB6TbeXgqSM/S5/dNh0GYHwyvNs3BNoRwvph+8riu6l9wCrpnjovhvI7wXFtZBmBo2fyTKU=  ;
X-YMail-OSG: xp729AwVM1lvxIIZp8zN0bf9OaXkGdij6m.2R_tGBL6Xw0R5y8h4axwmGlJ8ARFvId_Qisxs.QzzUXMZVvfkYj0Ow939cJ62t8qjRcfhqbQpBYBxJ.2VjZxV7BRPxxlL7.Exi0Om4c3wiUqngJ8FHUo75Ea9rzqqWfLUqjvm
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "Morton, Andrew" <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.28-rc8
Date: Thu, 11 Dec 2008 18:57:36 +1100
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812111857.36862.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 December 2008 12:04, Linus Torvalds wrote:
> Nothing overly exciting here. Lots of small things, mostly in drivers
> (with some defconfig updates for m68k and mips making the diffs bigger).
>
> There's some uncomfortably big changes to the intel DRI code, but most of
> that is all about fixes to the new i916 "GEM" code that is only used by
> development X servers, and is a new feature, so it shouldn't be able to
> cause regressions.
>
> Perhaps more interesting is simply the release scheduling issue. I'm
> getting slowly ready to do a real 2.6.28, but I don't think anybody really
> wants the merge window to be around the holidays. So the question is
> really whether to
>
>  (a) just make the -rc's go on a few more weeks, and do 2.6.28 after xmas
>
>      I like this, because alledgely people are debugging things, and we'd
>      get a more stable 2.6.28.

I still have one fix for a reported regression (softlink code doesn't
honour GFP_NOFS, caused by a patch of mine). Posted a couple of weeks
ago, but it didn't get anywhere.

I thought it would be good to have in 2.6.28, but it's been present in
a couple of releases now, so maybe Andrew didn't think it worth the
trouble?
