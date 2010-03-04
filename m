Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab0CDWVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 17:21:53 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64422 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab0CDWVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 17:21:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AfabEo0JRX1IJcu9GASFVYYiSpya3vTsbcXfLyHg4oaDu6ljONjVLHRYHFfMP9XxIc
         t2XZ7ySAwkmFc9S9tM+w6Ac29E5rOvq1mrb++tbLlY5Kxys5ndoxNTRWLEn3sdMrboBM
         apa7oH266+2zFz5wOH2H32VGgWxHUyT/FHl7U=
Message-ID: <4B903273.90305@garzik.org>
Date: Thu, 04 Mar 2010 17:21:39 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Adam Jackson <ajax@redhat.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, Dave Airlie <airlied@linux.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>	 <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>	 <alpine.LFD.2.00.1003041035380.3751@localhost.localdomain>	 <20100304185002.GA23532@srcf.ucam.org>	 <alpine.LFD.2.00.1003041051470.3751@localhost.localdomain>	 <20100304190450.GA23807@srcf.ucam.org>  <4B900AB2.1020603@garzik.org> <1267741133.1316.9.camel@atropine.boston.devel.redhat.com>
In-Reply-To: <1267741133.1316.9.camel@atropine.boston.devel.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2010 05:18 PM, Adam Jackson wrote:
> On Thu, 2010-03-04 at 14:32 -0500, Jeff Garzik wrote:
>> On 03/04/2010 02:04 PM, Matthew Garrett wrote:
>>> F-12 continues to ship the -nv driver, which will work fine with any
>>> kernel version as long as nouveau is disabled.
>>
>> FAIL.  I actually tried that.  Have you?  Do you think it is remotely
>> easy for a technically component, non-Xorg-hacker type to accomplish?
>
> # cat<<  EOF>  /etc/X11/xorg.conf
> Section "Device"
>      Identifier "Card0"
>      Driver "nv"
> EndSection
> EOF

Already tried that, and other suggested variations thereof.

Did not work on F11 or F12 with
05:00.0 VGA compatible controller: nVidia Corporation GeForce 9800 GX2 
(rev a2)


> # sed -i 's/\<kernel\>.*/&  nouveau.modeset=0/g' /etc/grub.conf

Never tried this part.

	Jeff


