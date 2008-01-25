Return-Path: <linux-kernel-owner+w=401wt.eu-S1761365AbYAYV6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761365AbYAYV6Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755205AbYAYV6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:58:17 -0500
Received: from gw.goop.org ([64.81.55.164]:50398 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754810AbYAYV6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:58:16 -0500
Message-ID: <479A5B72.6080701@goop.org>
Date: Fri, 25 Jan 2008 13:58:10 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jon Masters <jonathan@jonmasters.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] driver core patches against 2.6.24
References: <20080125071127.GA4860@kroah.com>  <alpine.LFD.1.00.0801251035150.2979@hp.linux-foundation.org>  <20080125185213.GA23475@suse.de>  <alpine.LFD.1.00.0801251108480.2979@hp.linux-foundation.org>  <479A3ED3.6020808@goop.org> <1201296027.32422.80.camel@perihelion> <alpine.LFD.1.00.0801251347010.5056@hp.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0801251347010.5056@hp.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Fri, 25 Jan 2008, Jon Masters wrote:
>   
>> Right. I assumed that Linus was calling mkinitrd but was being bitten by
>> one of the occasional assumptions (I believe we make in that script)
>>     
>
> No. I really am not. My /etc/grub.conf looks like this:
>
> 	title Linux
> 	        root (hd0,0)
> 	        kernel /vmlinuz ro root=/dev/VolGroup00/LogVol00 rhgb quiet
> 	        initrd /initrd-2.6.23.14-107.fc8.img
>
> ie I literally run the fedora initrd.
>
> I switch kernels, not initrd's. I don't even want to know if the initrd 
> contains some distro-specific setup...

The distro mkinird can reconstruct it containing your freshly built 
modules (if any) and any other distro goo which needs to go in there.   
/initrd-2.6.23.14-107.fc8.img doesn't come out of an rpm; its built by 
an installer script when you install the kernel, and you can run the 
same script on your kernels.

Does you use "make modules_install install" when you build the kernel? 
It just does the right thing for me under F8, including rebuilding 
initrd and updating grub.conf.

    J
