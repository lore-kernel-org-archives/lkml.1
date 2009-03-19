Return-Path: <linux-kernel-owner+w=401wt.eu-S1760759AbZCSSMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760759AbZCSSMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 14:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760608AbZCSSLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 14:11:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:46872 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760599AbZCSSLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 14:11:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FZVCY/MOuw9Du5AEHIGA8Qu752OUxUVF0Nll2snKlN5sxxdiI2JbqqwzxPrjs0L9QC
         18uKhKXMy/Svl/9Q0QHIN14jZpVILQjhL7zLbluPtriWnOqQ+1/YSS8VVgVLYnPPFgqw
         jqiujzxko6QppFoQyC5uPeB5Hk9wpZY9lv/68=
MIME-Version: 1.0
In-Reply-To: <20090319162719.GB32078@kroah.com>
References: <20090319040809.GA29249@kroah.com>
	 <6c046ab30903190903r298a0334n939e64403b8aeda6@mail.gmail.com>
	 <20090319162719.GB32078@kroah.com>
Date: Thu, 19 Mar 2009 14:11:18 -0400
Message-ID: <6c046ab30903191111y408a6c9g4cb392ad0331c011@mail.gmail.com>
Subject: Re: [patch 0/5] Intel Poulsbo/Morrestown DRM driver and DRM core 
	changes
From: Sindhudweep Sarkar <sindhudweep.sarkar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <greg@kroah.com>, David Airlie <airlied@linux.ie>,
       dri-devel@lists.sourceforge.net,
       Thomas Hellstrom <thellstrom@vmware.com>,
       Richard Purdie <rpurdie@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Of course real support for poulsbo is really important and desirable
since netbooks make such a huge percentage of computer sales these
days. I'm guessing, however, that the number of
embedded/mobile/appliance devices that use or will use the SGX5xx is
much larger than even the plethora of netbooks being pumped out. If
more hardware support can be gained for a little extra burden why not
go for it? I would argue that a unified driver stack would actually
have less maintenance cost since common bugs could be killed. Even
ignoring all the arm devices that will use that graphics core, what
about intel's own use of the SGX 535 elsewhere? Does this "poulsbo"
driver support the intel CE3100 processors?


I think i'm really apprehensive about device specific one-offs. Of
course a mainline driver upstream is an important step to prevent that
but without a roadmap it only seems marginally better.

Best,
Sindhudweep

On Thu, Mar 19, 2009 at 12:27 PM, Greg KH <greg@kroah.com> wrote:
> On Thu, Mar 19, 2009 at 12:03:09PM -0400, Sindhudweep Sarkar wrote:
>> This might be the opinion of a completely non educated end user but it
>> seems that an intel specific drm and other bits (xorg, mesa) would be
>> somewhat of a maintenance waste.
>
> What do you mean by this?
>
>> TI-OMAP 3xxx and a couple of other arm processors use similar SGX-5xx
>> graphics cores. IIRC arm is often little endian so perhaps a unified
>> driver would be easier in the long term.
>
> Long term lots of things are good.
>
> But how do I get my laptop that I currently have right now up and
> running properly with linux in a better-than-800x600-framebuffer mode?
>
> That's why I need/want this driver now, there are hundreds of thousands
> of these types of laptops in the pipeline to users and I want them to
> run Linux, not be forced to run some other operating system...
>
> thanks,
>
> greg k-h
>
