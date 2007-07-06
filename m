Return-Path: <linux-kernel-owner+w=401wt.eu-S1760821AbXGFOkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760821AbXGFOkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 10:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763000AbXGFOka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 10:40:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:37167 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762935AbXGFOk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 10:40:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=fX2D+ktE75JeSVMyzvjLcbx7sp5ohPs5m4HVehoKTS10z2qEnu/SnR/bnudo2YKljUjeLAyOyTMXxq5b3InmgTAWwviK9ffBm2SNzgFC9R6lNFEK9GNReZcwUV060WVn/IAhE1IZjb38zrt3vP5rttbRNCq/IkB8fuGH7ngr8/o=
Message-ID: <468E5458.2060003@googlemail.com>
Date: Fri, 06 Jul 2007 16:40:24 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: PATA-disk named sda
References: <20070706102132.14fbc600.Christoph.Pleger@cs.uni-dortmund.de>	<20070706111848.43551f33@the-village.bc.nu> <20070706143055.01aa9ef6.Christoph.Pleger@cs.uni-dortmund.de>
In-Reply-To: <20070706143055.01aa9ef6.Christoph.Pleger@cs.uni-dortmund.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Pleger wrote:
> Hello,
>   

Hi,

>   
>>> In the newest Ubuntu Release, my PATA-disk is called sda instead of
>>> hda. Is that a general feature in newer kernel versions or is it a
>>> special feature in Ubuntu?
>>>       
>> General. SATA and now PATA drives map onto the /dev/sd range as do
>> SCSI, USB etc
>>     
>
> It seems to be not that simple, at least not if both the old IDE
> interface and the new libata interface are enabled as modules: In my
> Ubuntu system, I created two kernel packages (from the same kernel
> source and with the same configuration) and installed them. Afterwards,
> I re-created the initial ramdisks, one with the Ubuntu feisty utilities
> and one with Debian etch utilities. So, I had the same kernel with
> different ramdisks. With the Ubuntu ramdisk, my harddrive was named sda,
> but with the Debian ramdisk, it was named hda.
>
> So, the name of the drive can depend on something which happens in the
> ramdisk environment. Does anybody know what that is? And is there a
> kernel command line parameter which restores the old behaviour?
>   

The boot options are different depending on the distribution you are using.
Every distribution has his own magic for this kind things. ( Debian and 
Ubuntu should have a man page with boot parameters )

On kernels with both IDE and PATA enabled as modules , depends on what 
you load first / include in your initramfs.
If you load the IDE subsystem first you get HD*'s while with PATA you 
get SD*'s.

I don't use Debian nor Ubuntu but it looks like Ubuntu has PATA as 
default while Debian has IDE.

> Regards
>   Christoph
>   

Gabriel
