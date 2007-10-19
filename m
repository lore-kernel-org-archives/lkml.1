Return-Path: <linux-kernel-owner+w=401wt.eu-S935987AbXJSR5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935987AbXJSR5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 13:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764789AbXJSR5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 13:57:34 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:21533 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932973AbXJSR5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 13:57:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=5CfxappfTVQSKNkZQgS3wA0qynUpq9z9KHo133OoXaUgupImzX4h3iikH2idb/GJWmXQyK1HuUu4nKgCJDmA9G5W9zBS0TuoO1fO5cqpE2LI7SNnJeu0JVX1Sxqmv82dbO+mh043m5OP4Q/76zzohRd0kMiH3Il3/ZpWtKsoZmQ=  ;
X-YMail-OSG: t5QsIU0VM1mQDOHy2d7T0V1GHULPMgBLLROIf5nJ3epXinzN2foheW6GUNRX691OWp4boO0Xl.3YpWDZQPA08ucyffxjUr5aF0P75SFlCgui2d1ppWNUJCW_nvxj
Date: Fri, 19 Oct 2007 10:57:30 -0700
From: David Brownell <david-b@pacbell.net>
To: cooloney.lkml@gmail.com
Subject: Re: [PATCH 02/10] Blackfin SPI driver: use new GPIO API and add error handling
Cc: spi-devel-general@lists.sourceforge.net, michael.hennerich@analog.com,
       linux-kernel@vger.kernel.org, bryan.wu@analog.com,
       akpm@linux-foundation.org
References: <1192158304-8277-1-git-send-email-bryan.wu@analog.com>
 <200710112326.34500.david-b@pacbell.net>
 <1192172077.6247.15.camel@roc-laptop>
 <200710121017.47645.david-b@pacbell.net>
 <386072610710172306m2a0831eds646da3d7c78809bb@mail.gmail.com>
In-Reply-To: <386072610710172306m2a0831eds646da3d7c78809bb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071019175730.8546323A5F7@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > In fact, if I look at the kernel.org GIT tree, it doesn't have
> > them either.  Your tree must have somehow gotten a bunch of
> > private changes.
>
> Did you apply these patches, or I need resent a new patchset against
> latest Linus GIT tree?

I'm still not quite sure why the patches you sent didn't apply
for me.  Why don't you send refreshed patches to me after RC1.


> I noticed in latest GIT tree the Blackfin SPI driver are modified.

Yes, various cleanup patches.  Missing newlines in dev_*() calls,
class_device removal, remove extra includes, and so forth.  They
might conflict with your patches (I suspect they won't).

That's a big part of why you should arrange to submit patches well
in advance of the merge window opening.  As a rule, maintainers
won't have/make extra time during that window to review and/or fix
nontrivial issues, or address conflicts with other patches.  Try to
submit at least a few weeks before the previous kernel finalizes.

- Dave

