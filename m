Return-Path: <linux-kernel-owner+w=401wt.eu-S1751911AbXCSIWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbXCSIWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 04:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbXCSIWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 04:22:21 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:23526 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbXCSIWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 04:22:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=njIAuXadEvxAablizHnue1RjI+Q5wDdgDiP+7wqqMFHgf7/VUV9dQ48wOEeqYr84Vc8pLguimk1UtIv6sOs4xDY85JD9TJTzsq76vTx8XGAuWiuGq7x0T/ls7uGh81icjuX5lgpPjCOKy+IebSDwIlNrMlxcwvUNTbPD45cgsbc=
Message-ID: <45FE4836.4060102@gmail.com>
Date: Mon, 19 Mar 2007 17:22:14 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Alistair John Strachan <s0348365@sms.ed.ac.uk>
CC: Frank van Maarseveen <frankvm@frankvm.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.20*: PATA DMA timeout, hangs (2)
References: <20070312085447.GA10955@janus> <200703121207.19042.s0348365@sms.ed.ac.uk> <20070312132546.GC12265@janus> <200703121352.19505.s0348365@sms.ed.ac.uk>
In-Reply-To: <200703121352.19505.s0348365@sms.ed.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alistair John Strachan wrote:
> On Monday 12 March 2007 13:25, Frank van Maarseveen wrote:
> [snip]
>> So, are /dev/hd* going to disappear in a few years? iow, does it make
>> sense to _slowly_ start to migrate to /dev/sd*?
> 
> How would you propose doing this? I'm sure modern distros with an 
> initrd/initramfs probably already do some sort of root detection. Doesn't fix 
> the fstab issue, but I suppose this could be auto-generated too.
> 
>> The problem is there's no plan B in case of any troubles except rename
>> everything back again to boot an old kernel.
> 
> I doubt this matters for distributors, as they'll simply switch over when you 
> upgrade the distro, and the earliest supported kernel will be the one that 
> shipped with the newer version.
> 
> I accept that it's a bit of a drag, but it's better to have a standard naming 
> convention for all disks, isn't it?

The solution is quite simple.  Use the LABEL= trick or other methods to 
uniquely identify the partition regardless how it's connected.  Most 
modern distributions are already doing this.

-- 
tejun
