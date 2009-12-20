Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZLTVLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZLTVLM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 16:11:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZLTVLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 16:11:11 -0500
Received: from ns3.baby-dragons.com ([64.62.236.141]:46264 "EHLO
	ns3.baby-dragons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbZLTVLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 16:11:10 -0500
Date: Sun, 20 Dec 2009 12:10:47 -0900 (AKST)
From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
To: Dave Airlie <airlied@gmail.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-fbdev@vger.kernel.org,
       Linux Kernel Maillist <linux-kernel@vger.kernel.org>
Subject: Re: drivers/gpu/drm/radeon/radeon_test.c:45: undefined reference to
  `__udivdi3'
In-Reply-To: <21d7e9970912192211y6cb02557se261787f3b56d2a8@mail.gmail.com>
Message-ID: <alpine.LNX.2.01.0912201209250.9200@filesrv1.baby-dragons.com>
References: <alpine.LNX.2.01.0912181147200.9874@filesrv1.baby-dragons.com> <21d7e9970912192211y6cb02557se261787f3b56d2a8@mail.gmail.com>
User-Agent: Alpine 2.01 (LNX 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="566704117-281555746-1261343454=:9200"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (ns3.baby-dragons.com [64.62.236.141]); Sun, 20 Dec 2009 21:10:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--566704117-281555746-1261343454=:9200
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

 	Hello Dave ,

On Sun, 20 Dec 2009, Dave Airlie wrote:
> On Sat, Dec 19, 2009 at 6:54 AM, Mr. James W. Laferriere
> <babydr@baby-dragons.com> wrote:
>>        Hello Benjamin ,  I am not having a good time compiling 2.6.32.1 .
>> First RCU 'inline' difficulties then fusion-mpt 'inline' difficulty ,  Now
>> this .
>>        This one is not a simple as removing 'inline' from a statement .
>>        Would you please look into this ?  Anything else you need please just
>> ask .
>>        Please cc: me as I am not subscribed to linux-fbdev .
>>
>>                Tia ,  JimL
>>
>
> Can you try the attached patch?
>
> Dave.

 	With the below DRM items configured .  The patch allows me to complete 
the compilation of linux ...

# grep -i drm .config
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_TTM=y
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
CONFIG_DRM_I810=y
# CONFIG_DRM_I830 is not set
CONFIG_DRM_I915=y
# CONFIG_DRM_I915_KMS is not set
CONFIG_DRM_MGA=y
CONFIG_DRM_SIS=y
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y

# dir -alrt arch/x86/boot/bzImage
6336 -rw-r--r-- 1 root root 6475472 2009-12-20 21:01 arch/x86/boot/bzImage


 		Hth ,  JimL
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 3237     Holden Road |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99709 |   only  on  AXP |
+------------------------------------------------------------------+
--566704117-281555746-1261343454=:9200--
