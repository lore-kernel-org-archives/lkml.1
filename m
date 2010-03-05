Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab0CEBxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 20:53:53 -0500
Received: from mail-yw0-f184.google.com ([209.85.211.184]:63002 "EHLO
	mail-yw0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab0CEBxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 20:53:52 -0500
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Mar 2010 20:53:52 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RByHQgTkyvB+l6Lh3d51TAJlynwBzvtks2+9h+dIrtDSVN8rwXcLEYXavCCEK9wEzM
         avloXd9FrMjL34PLtLh0EG1Z3B7293NI9+IEG03QYkznSA1N3pgU6IWPba7fqtsli6IQ
         attIlYppheErZ6OUkGf2cM04aNqTIcYzimql0=
Message-ID: <4B9062B7.1020609@gmail.com>
Date: Thu, 04 Mar 2010 19:47:35 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie> <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain> <alpine.LFD.2.00.1003041035380.3751@localhost.localdomain> <20100304185002.GA23532@srcf.ucam.org> <alpine.LFD.2.00.1003041051470.3751@localhost.localdomain> <20100304190450.GA23807@srcf.ucam.org> <4B900AB2.1020603@garzik.org>
In-Reply-To: <4B900AB2.1020603@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2010 01:32 PM, Jeff Garzik wrote:
> On 03/04/2010 02:04 PM, Matthew Garrett wrote:
>> "Please note that these drivers are under heavy development, may or may
>> not work, and may contain userspace interfaces that most likely will be
>> changed in the near future."
>
> Shipping it as the default Fedora driver for NVIDIA hardware makes that
> text largely irrelevant.

Indeed, that text isn't really reconcilable with the fact that the 
driver is being used by default in a stable distro release. (Why do 
people keep forgetting the whole "upstream development" thing?)

>
> Jesse said
>> Dave and the nouveau guys include the driver in Fedora to get
>> much needed test coverage, and make sure the latest bits in rawhide
>> work together.
>
> but when it is the default driver, it is the default _production_ driver
> for Fedora users, in an official, stable Fedora release.
>
> And the alternative? You said
>> F-12 continues to ship the -nv driver, which will work fine with any
>> kernel version as long as nouveau is disabled.
>
> FAIL. I actually tried that. Have you? Do you think it is remotely easy
> for a technically component, non-Xorg-hacker type to accomplish?
>
> I attempted to use the non-default 'nv' driver just before nouveau was
> merged into upstream/staging, because I wanted a development kernel that
> actually worked on my Fedora-based devel boxes. It was a complete
> exercise in frustration, requiring at least one bugzilla bug report, and
> ultimately resulted in failure.

Advising people to use nv is pretty much a joke IMHO, it's barely above 
VESA in some ways. People would be more likely to use the nvidia binary 
driver than that contraption..

Aside from the fact that running nouveau on this machine would drive me 
crazy (there's no fan speed control implemented so the GPU fan screams 
away at maximum speed), the other big reason I can't use it is that at 
least until quite recently it couldn't work with upstream kernels. 
Unfortunately, changes like this will being that problem back..

So at this point the nvidia binary driver is the most practical solution 
that actually meets my needs, sadly enough..

>
> I gave up and waiting for Linus to merge nouveau, which instantly made
> my life a lot easier :)
>
> Kernel hacking on Fedora, my own dogfood, has become increasingly
> cumbersome because of all these graphics issues. Sometimes it's just
> easier to test a modern kernel on an ancient distro, sadly.
>
> Jeff
>
>
>

