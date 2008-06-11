Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbYFKHpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbYFKHpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 03:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbYFKHpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 03:45:10 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:58949 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbYFKHpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 03:45:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=W6T9lPxq9JenrvUWQTFYfNpBSU3imr64JX2ZcocnFbuB90Z/XK+iE2UTSsAHBKvQhq
         H+0Vpxd2/3pxOgDY5+bQuvBwi1ydSAiqYestyLGrEZOHy+Bb4eBpu3CfexIftO6TDPIl
         4eFWCfAjVNKgYa6d5hr4uKLozBlsozjLIG2qc=
Message-ID: <dd18b0c30806110045s6d19a034yd89b892441bd1621@mail.gmail.com>
Date: Wed, 11 Jun 2008 07:45:05 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: macbook pro dvd playback after suspend Buffer I/O error
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
In-Reply-To: <484F31B8.8030001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30804032207u36bd1f43l358e9949f0c94f79@mail.gmail.com>
	 <20080404012147.abf8a598.akpm@linux-foundation.org>
	 <484F31B8.8030001@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 2:00 AM, Tejun Heo <htejun@gmail.com> wrote:
> Andrew Morton wrote:
>> On Fri, 4 Apr 2008 05:07:45 +0000 "Justin Mattock" <justinmattock@gmail.com> wrote:
>>
>>> When playing a DVD and then suspending the system while the DVD is
>>> still in play, upon wakeup I'm receiving a Buffer I/O error on device
>>> sr0, logical block 356490.
>>> the DVD will continue to play but then gmplayer complains: Warning!
>>> FPS changed 23.976 -> 29.970 (-5.994005) [4] then the video becomes
>>> very choppy. When looking at osx in the same test the DVD will be
>>> paused until the cd player aligns itself, then playback will start.
>>> With looking further at this I think this is an issue of a library or
>>> codec, So with this in mind is there a package that I might look at to
>>> see if this resolves the issue. Attached is dmesg of the Buffer I/O
>>> regards;
>>
>> An ata thing, I assume.  Let's cc linux-ide.
>>
>> Is this new behaviour in 2.6.25-rc8, or were earlier kernels OK?
>
> This is due to UNIT ATTENTION condition triggered by reset during
> resume.  The following patches should fix it.
>
> http://marc.info/?l=linux-ide&m=121309016918976&w=2
> http://marc.info/?l=linux-ide&m=121309016918979&w=2
>
> Thanks.
>
> --
> tejun
>

alright!! I'll give that a test and see; give me some time right now
it's midnight, and a couple of beer's in; so doing anything that
requires
thinking isn't going to happen, but tomorrow it will.
regards;

-- 
Justin P. Mattock
