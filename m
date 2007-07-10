Return-Path: <linux-kernel-owner+w=401wt.eu-S1763578AbXGJJN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763578AbXGJJN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759532AbXGJJNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:13:50 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:50409 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757684AbXGJJNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:13:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Yd/YSfjrAqCarxBw5PBSRnl4lIDvoMZBIzRQi1iRPtFqbAPpYamnWbOTud93M7UJEvnfSD1rEWvZP6864y/gpSKpdBrA0TDQs5jpJXHHPFTZTW1oiUS5QX+gaF42Ze3j5/oM9UqEjQa6jvI64ShMFo+aciDvUyoXmF6S99MGNRI=
Message-ID: <46934DC7.1020104@gmail.com>
Date: Tue, 10 Jul 2007 18:13:43 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Sysfs and suicidal attributes
References: <Pine.LNX.4.44L0.0707081015430.5323-100000@netrider.rowland.org>	<46931495.4050605@gmail.com>	<20070710102857.15a57337@gondolin.boeblingen.de.ibm.com>	<46934821.5020409@gmail.com> <20070710110447.0f63baf3@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070710110447.0f63baf3@gondolin.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Tue, 10 Jul 2007 17:49:37 +0900,
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> What I was trying to say was that suicide and murder could be done the
>> same way from the driver's POV or am I misunderstanding?
> 
> Do you mean a device unregistering itself from its attribute vs. a
> device unregistering another device from its attribute?

More like "device unregistering itself from its attribute" vs. "whatever
else".

>>> A general immediate disconnect of the buffers (which will be handled in
>>> a second pass) would be great, but doesn't sound easy.
>> I haven't thought too hard about actual implementation but it's pretty
>> specific case.  If doing things in generic manner is difficult, there
>> are plenty of shortcuts to choose from, I think.
> 
> The "second pass" approach where the store method calls the sysfs core
> or sets a flag or whatever sounds doable, but I'm not sure how general
> we can get. Maybe for all store methods that just trigger an action.

Hmm... I'll give it a shot in a few days.

-- 
tejun
