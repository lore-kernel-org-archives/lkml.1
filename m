Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbXIWJUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbXIWJUy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 05:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbXIWJUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 05:20:46 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:3633 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbXIWJUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 05:20:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YIoGBTFFKwhawb+2humqGdE4hBB1SB/BGCL+1IySnjMn1KPQSllEmbjrETBgsa6Rr9tS1cbSaa6MQ6bEUnhyVA4tieIh3rLHjsNdsVz7Wf4S8VVupNjjXS+WLzj+6GtCe8h9HCZCn9yY6dDZVXpKipJm8S/TRcOUO2aC74dQ1eQ=
Message-ID: <19f34abd0709230220h6d37c27bva2d5502f9f0d6931@mail.gmail.com>
Date: Sun, 23 Sep 2007 11:20:44 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: [RFC] New kernel-message logging API
Cc: "Joe Perches" <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
       holzheu <holzheu@linux.vnet.ibm.com>, "Rob Landley" <rob@landley.net>,
       "Dick Streefland" <dick.streefland@altium.nl>
In-Reply-To: <Pine.LNX.4.64.0709231044290.15712@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com>
	 <1190506383.30132.11.camel@localhost>
	 <19f34abd0709230139s56b9a9b1yc2cae89488ea5112@mail.gmail.com>
	 <Pine.LNX.4.64.0709231044290.15712@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/23/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Sep 23 2007 10:39, Vegard Nossum wrote:
> >On 9/23/07, Joe Perches <joe@perches.com> wrote:
> >> On Sat, 2007-09-22 at 21:27 +0200, Vegard Nossum wrote:
> >> > #define kprint(fmt, ...)
> >>
> >> Good ideas.  Perhaps a prefix of klog or kp_ instead?
> >> Given the number of 80 column zealots, character naming length matters.
> >
> >I don't know. Compare the following two lines:
> >
> >printk(KERN_INFO "Message.\n");
> >kprint_info("Message.");
> >
> >By dropping the lengthy macro (it's not like it's going to change
> >while we're running anyway, so why not make it a part of the function
> >name?) and the final newline, we actually end up with a net decrease
> >in line length.
> >
> >I thought it would be nice to have something that looks familiar,
> >since that would ease an eventual transition. klog is a valid
> >alternative, but isn't kp a bit cryptic?
>
> I'd rather fix up code to reduce its indent rather than
> trying microoptimizations at the function name level!

Well, that's a different discussion, really. Is fixing the body of
[v]printk() enough? I don't think it's possible if you want to do
everything that I described in my original post.

It's not even an optimization from my point of view; I think Joe
Perches was arguing that code should be kept short. I was arguing that
it's already shorter than with the current situation.


Vegard
