Return-Path: <linux-kernel-owner+w=401wt.eu-S1763706AbYBVGhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763706AbYBVGhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 01:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbYBVGhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 01:37:06 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:13584 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbYBVGhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 01:37:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=MlhV7vpOrNCxi1DY9KMSJwPCrygaMTzjx9OdAhv3pqFTfdHgwcgwqAvEvg7rekZe3hDaGEBafjCbx2Fl8H/g+aZNmqteL/KTUGlNV+C3WudqWi0crgFcpTLCgxNaQNglgfQHThwJujgHrrjd9Pj0Lu3BcQZq9jqEpk0tGvhgLi0=
Message-ID: <2c0942db0802212237t41da54b4h2aa2b052b7633f53@mail.gmail.com>
Date: Thu, 21 Feb 2008 22:37:00 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Merging of completely unreviewed drivers
Cc: "Al Viro" <viro@zeniv.linux.org.uk>,
       "David Newall" <davidn@davidnewall.com>,
       "Krzysztof Halasa" <khc@pm.waw.pl>, "Adrian Bunk" <bunk@kernel.org>,
       "Roland Dreier" <rdreier@cisco.com>,
       "Glenn Streiff" <gstreiff@neteffect.com>,
       "Faisal Latif" <flatif@neteffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Greg Kroah-Hartman" <greg@kroah.com>
In-Reply-To: <alpine.LFD.1.00.0802211858140.19896@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2>
	 <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2>
	 <20080221154951.GA28328@cs181133002.pp.htv.fi>
	 <adahcg2awag.fsf@cisco.com>
	 <20080221210124.GD28328@cs181133002.pp.htv.fi>
	 <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org>
	 <m3tzk1q3rt.fsf@maximus.localdomain>
	 <47BE2985.6020305@davidnewall.com>
	 <20080222020615.GE27894@ZenIV.linux.org.uk>
	 <alpine.LFD.1.00.0802211858140.19896@woody.linux-foundation.org>
X-Google-Sender-Auth: f1aa745b7150394c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 7:13 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>  So I'd be happier with warnings about deep indentation (but how do you
>  count it? Will people then try to fake things out by using 4-space indents
>  and then "deep" indentations will look like just a couple of tabs?)

I suspect that 90% of the cases that people really care about would
get caught successfully just by counting brace depth.

ie, by looking at { { {} {} {{{}{}}} } } I bet you can tell me which
section should have been pulled out into a separate routine.
