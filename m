Return-Path: <linux-kernel-owner+w=401wt.eu-S1759409AbZKZIEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409AbZKZIEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759364AbZKZIET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:04:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:47015 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759279AbZKZIES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:04:18 -0500
Message-ID: <4B0E3677.6000603@kernel.org>
Date: Thu, 26 Nov 2009 17:04:07 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>, Takashi Iwai <tiwai@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: linux-next: workqueues tree build failure
References: <20091126190050.3f9d7fef.sfr@canb.auug.org.au>
In-Reply-To: <20091126190050.3f9d7fef.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

11/26/2009 05:00 PM, Stephen Rothwell wrote:
> Hi Tejun,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> sound/soc/codecs/tlv320dac33.c: In function 'dac33_i2c_probe':
> sound/soc/codecs/tlv320dac33.c:1121: error: implicit declaration of function 'create_rt_workqueue'
> sound/soc/codecs/tlv320dac33.c:1121: warning: assignment makes pointer from integer without a cast
> 
> Caused by commit 1b2d88bf4c63ed3a8c9033c358905d3463aa8bc2 ("stop_machine:
> reimplement without using workqueue") (which removed create_rt_workqueue
> ()) interacting with commit c8bf93f0fe8c5a509a29e30f3bac823fa0f6d96e
> ("ASoC: Codec driver for Texas Instruments tlv320dac33 codec") from the
> sound tree.
> 
> I have no idea how to fix this, so I have used the workqueues tree from
> next-20091125 until someone can suggest a solution.

Takashi, RT workqueue is going away.  Do you really need it?

Thanks.

-- 
tejun
