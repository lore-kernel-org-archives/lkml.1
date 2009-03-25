Return-Path: <linux-kernel-owner+w=401wt.eu-S1758868AbZCYKOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868AbZCYKOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 06:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbZCYKNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 06:13:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:48138 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbZCYKNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 06:13:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SBg6Kr531rSzDTOJX02sUxIhofLSu8BM658Vil1ICuif5Ens4vAQ+js/wX/jGf3aZf
         oNby+nD4sCV10hQlY6SRf09U1SMAwQ+SUsriyfgTwO9vZaXC3srkaez/Fq+45UEyEVvt
         AvqYPMMb1O+WDfEN+e8tjmoetxBrz9vRxALV8=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0903250817090.5590@axis700.grange>
References: <1232458448-4412-1-git-send-email-tom.leiming@gmail.com>
	 <Pine.LNX.4.64.0903250039160.4451@axis700.grange>
	 <d82e647a0903241815l66abfc18ldbb26abd7d2c6b4@mail.gmail.com>
	 <Pine.LNX.4.64.0903250817090.5590@axis700.grange>
Date: Wed, 25 Mar 2009 18:13:51 +0800
Message-ID: <d82e647a0903250313ka2d270ag78335e7c7f525f22@mail.gmail.com>
Subject: Re: [PATCH] driver core: check bus->match without holding device lock
From: Ming Lei <tom.leiming@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: kay.sievers@vrfy.org, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > Now, without .match() no probing is done. Is this an intended change and
>> > soc-camera has to be fixed or is this a bug?
>>
>> It is not a driver-core bug, and soc-camera should be fixed.
>
> So, you're saying this used to be a bug and it has been fixed by this
> patch? Then why isn't this mentioned in the commit message? The commit
> text seems to suggest, that this patch shouldn't introduce any change in
> behaviour, but it does. So, before .match == NULL lead to .probe() being
> called, and now it doesn't anymore?

Where is soc-camera  driver in kernel tree?  Which bus  is soc-camera
device (driver) attached to ?
Why doesn't soc-camera  driver  have a match method?

Thanks!


-- 
Lei Ming
