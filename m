Return-Path: <linux-kernel-owner+w=401wt.eu-S932444AbXJTRYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444AbXJTRYs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 13:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757203AbXJTRYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 13:24:39 -0400
Received: from wx-out-0506.google.com ([66.249.82.226]:63499 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757332AbXJTRYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 13:24:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=eZKid1RBVlPEs9jxIpSWTOL6mEsxtBxCOb4BpMdaQmzCmALiYpQkRxadimyfZNLWsAXxhZL1hR4dPMOC/jDONBxA7a7T9YEftNSk8+VFEiTQvZY2+bfwsbsK8AajOpgkDzbp53WxutgfFptXMrHCv6e55NMY4chdpKA0t6KTFwg=
Message-ID: <471A39D2.1070303@gmail.com>
Date: Sat, 20 Oct 2007 13:24:34 -0400
From: emist <emistz@gmail.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Linux <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Bug fix for the s390 dcssblk driver
References: <200710201451.57138.elendil@planet.nl>
In-Reply-To: <200710201451.57138.elendil@planet.nl>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> emist wrote:
>> The following patch fixes and issue in the s390 dcssblk driver. The
>> issue is caused when an unsuccessful attempt is made in order to change
>> a segment's type through the device attribute file "shared". This causes
>> the driver to remove the device in question, removing with it the device
>> attribute which is currently handling the call. The result is a hang on
>> the driver as it removes memory from under its feet.
>>
>> Not exactly sure if this explanation makes sense or its entirely
>> accurate. This is what I believe at this point from encountering and
>> fixing the error. Anyway here is the patch, hope it helps.
> 
> Hi,
> 
> If you don't get any reactions to your patch during the next few days, I 
> suggest you resend it and then CC the linux-s390@vger.kernel.org list and 
> possibly also the maintainer at linux390@de.ibm.com.
> 
> In general you should always try to CC the relevant list/people as listed in 
> the MAINTAINERS file and not just the linux-kernel list, both for patches 
> and when reporting problems.
> 
> Cheers,
> Frans Pop
> 

Thanks Frans, I will do as you suggest.

Have a good one,

Igor H.
