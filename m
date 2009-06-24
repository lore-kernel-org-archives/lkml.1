Return-Path: <linux-kernel-owner+w=401wt.eu-S1760241AbZFXOcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760241AbZFXOcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 10:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757342AbZFXOb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 10:31:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:56915 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293AbZFXOb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 10:31:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pNFCDBOfODn/8g231qxLFZORti28w7JTH1Lf1vDSH70AfNZA4iJxEISQ1AqX40CpEe
         4sM+Ll5KecGKpE8L/ohQfzr39F8Jh2SsQGntsC4pn1D5I7JGeEa3hFDAx2/6QvVgQAHJ
         S+qtFHx5PWcBDoHp4nprzUoHc+4Ln+hQ4/Tw4=
Message-ID: <4A4238D2.2060501@googlemail.com>
Date: Wed, 24 Jun 2009 16:31:46 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090610)
MIME-Version: 1.0
To: Dave Airlie <airlied@linux.ie>
CC: Ma Ling <ling.ma@intel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] drm fixes + intel display port
References: <alpine.DEB.2.00.0906240723420.18292@skynet.skynet.ie> <1820d69d0906240715v6c3591c4x30ee87e9ec8774f7@mail.gmail.com>
In-Reply-To: <1820d69d0906240715v6c3591c4x30ee87e9ec8774f7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ forgot to CC LKML , sorry ]

Gabriel C wrote:

> 2009/6/24 Dave Airlie <airlied@linux.ie>:
>> Hi Linus,
>>
>> Please pull the 'drm-fixes' branch from
>> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes
>>
> 
> Hi Dave ,
> 
> I own an DQ45CB Intel motherboard. When enabling KMS with kernels from
> 2.6.29* to current git / linux-next on that board
> I don't get any console. My Monitor is saying 'No signal' , however
> once X starts up I can login in KDE/gnome etc.
> 
> The monitor is connected with an DVI-I -> VGA connector.
> 
> I found on the gfx mailing list the following patch from Ma Ling :
> 
> http://lists.freedesktop.org/archives/intel-gfx/2009-May/002504.html
> 
> which seems to fix my problem. With that patch applied I get a console
> and everything works fine.
> 
> However I still have such :
> 
> [   21.205449] i2c-adapter i2c-1: unable to read EDID block.
> [   21.205452] i915 0000:00:02.0: VGA-1: no EDID data
> 
> 
> messages in my dmesg but it works.
> 
> 
> Is there any reason why this patch never got merged ?
> 
> Best Regards,
> 
> Gabriel C


