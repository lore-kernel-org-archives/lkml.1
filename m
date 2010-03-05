Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab0CELYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 06:24:31 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41300 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab0CELYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 06:24:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=IIO25bf8V4Ih+b5df2HdBXEt++5QkNhHlgCGIazjeBsz69u+TtKl6+ZQ5ts7q5Q2i1
         rLU3IOGq0lYaMBzmIZKM5BIG5CoIRtJNBv1XArnS/jcMFqqe5GJXz4ShnD9lIFHoTgQ4
         k6goO1gUoeNDshyuE2YRystZQ4Qcqq0DerWmk=
Message-ID: <4B90E9EA.9030708@garzik.org>
Date: Fri, 05 Mar 2010 06:24:26 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Adam Jackson <ajax@redhat.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, Dave Airlie <airlied@linux.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>	 <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>	 <alpine.LFD.2.00.1003041035380.3751@localhost.localdomain>	 <20100304185002.GA23532@srcf.ucam.org>	 <alpine.LFD.2.00.1003041051470.3751@localhost.localdomain>	 <20100304190450.GA23807@srcf.ucam.org>  <4B900AB2.1020603@garzik.org>	 <1267741133.1316.9.camel@atropine.boston.devel.redhat.com>	 <4B903273.90305@garzik.org> <1267743599.1316.47.camel@atropine.boston.devel.redhat.com>
In-Reply-To: <1267743599.1316.47.camel@atropine.boston.devel.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2010 05:59 PM, Adam Jackson wrote:
> On Thu, 2010-03-04 at 17:21 -0500, Jeff Garzik wrote:
>
>>> # sed -i 's/\<kernel\>.*/&   nouveau.modeset=0/g' /etc/grub.conf
>>
>> Never tried this part.
>
> The bug I'm assuming you're referring to is
>
> https://bugzilla.redhat.com/show_bug.cgi?id=519298
>
> in which you merely remove the nouveau userspace component, and in which
> I can't tell if you built nouveau into the kernel or not, but I assume
> you didn't based on your previous post.  The X server does only try the
> one driver before falling back to vesa, which is a bug in the fallback
> logic I suppose.  I've (blindly) fixed that for F13 now.

Thanks.  Can this be put into F12 too?


> However, the log in that bug only shows you using the built-in
> autoconfig logic, and not an xorg.conf file.  So, given you were talking
> about a kernel without nouveau, I am left to assume one of:
>
> - you didn't try writing an xorg.conf fragment
> - you did, and it didn't work anyway
>
> The latter case is entirely plausible, as nv is not the sort of driver
> that gets a lot of love, but I'm not aware of any open bugs about gf9800
> in particular in nv.

The latter...  would modeset in grub interfere, perhaps?

	Jeff


