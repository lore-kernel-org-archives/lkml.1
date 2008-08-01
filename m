Return-Path: <linux-kernel-owner+w=401wt.eu-S1756842AbYHAIu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbYHAIu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 04:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbYHAIuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 04:50:18 -0400
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67]:55269 "EHLO
	webmail-outgoing.us4.outblaze.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752424AbYHAIuR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 04:50:17 -0400
X-Greylist: delayed 1170 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Aug 2008 04:50:17 EDT
X-OB-Received: from unknown (205.158.62.232)
  by wfilter.us4.outblaze.com; 1 Aug 2008 08:30:46 -0000
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
From: "Halesh S" <halesh.s@india.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: kosaki.motohiro@jp.fujitsu.com, halesh.s@india.com,
       linux-kernel@vger.kernel.org, madhvesh.s@ap.sony.com,
       halesh.sadashiv@ap.sony.com
Date: Fri, 1 Aug 2008 03:00:45 -0530
Subject: Re: mlock() return value issue in kernel 2.6.23.17
X-Originating-Ip: 125.17.166.34
X-Originating-Server: ws5-11.us4.outblaze.com
Message-Id: <20080801083046.15330CB59C@ws5-11.us4.outblaze.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Thanks everyone.
I confirm that the patch fixes the issue with Rlimit and invalid address.

Signed-off-by: halesh.sadashiv@ap.sony.com

Thanks,
Halesh



> ----- Original Message -----
> From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
> To: "Andrew Morton" <akpm@linux-foundation.org>
> Subject: Re: mlock() return value issue in kernel 2.6.23.17
> Date: Fri, 01 Aug 2008 16:23:40 +0900
> 
> 
> Hi Andrew,
> 
> > I assume that you tested it too?
> 
> Yes, my x86_64 box works well.
> 
> sorry, ambiguity e-mail.
> 
> halesh's test check two point.
>    - mlock rlimit
>    - invlid address range
> 
> and, I think rlimit already works well.
> So, I ask halesh re-confirming.
> 
> > If it comes down to a choice between complying with SuS versus
> > complying with earlier Linux versions then we'd usually prefer to
> > comply with earlier Linux versions.
> 
> I see.
> 
> > I queued this, but would prefer to await confirmation that it has been
> > tested to take us back to the 2.6.18 interface, please.
> 
> Yes.
> this patch wasn't tested on split-lru yet.
> I'll do that. (and probably fix it)
> 
> > Also, please send a Signed-off-by: for this change.
> 
> Agghh, sorry. it is stupid forgotten.

>


=


-- 
_______________________________________________
Search for products and services at: 
http://search.mail.com
