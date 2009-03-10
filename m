Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbZCJJmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbZCJJmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 05:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbZCJJmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 05:42:43 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:52112 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbZCJJmm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 05:42:42 -0400
X-IronPort-AV: E=Sophos;i="4.38,335,1233550800"; 
   d="scan'208";a="67623975"
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [alsa-devel] [PATCH 1/5] ASoC: Blackfin: fix bug - kernelwillcrash when record and play in bf527-ezkit
Date: Tue, 10 Mar 2009 17:45:44 +0800
Message-ID: <0F1B54C89D5F954D8535DB252AF412FA03AF7CAA@chinexm1.ad.analog.com>
In-Reply-To: <20090309112127.GB13593@sirena.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [alsa-devel] [PATCH 1/5] ASoC: Blackfin: fix bug - kernelwillcrash when record and play in bf527-ezkit
Thread-Index: AcmgqTMbEAoOK+SiQ1K6ObMmwty/zAAurz5A
References: <1236326010-683-1-git-send-email-cooloney@kernel.org> <1236326010-683-2-git-send-email-cooloney@kernel.org> <20090306120145.GF6493@sirena.org.uk> <0F1B54C89D5F954D8535DB252AF412FA03AB85F5@chinexm1.ad.analog.com> <20090309112127.GB13593@sirena.org.uk>
From: "Cai, Cliff" <Cliff.Cai@analog.com>
To: "Mark Brown" <broonie@sirena.org.uk>
Cc: "Bryan Wu" <cooloney@kernel.org>, <alsa-devel@alsa-project.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Mar 2009 09:42:40.0051 (UTC) FILETIME=[8D8EB030:01C9A164]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Mark Brown [mailto:broonie@sirena.org.uk] 
>Sent: Monday, March 09, 2009 7:21 PM
>To: Cai, Cliff
>Cc: Bryan Wu; alsa-devel@alsa-project.org; linux-kernel@vger.kernel.org
>Subject: Re: [alsa-devel] [PATCH 1/5] ASoC: Blackfin: fix bug 
>- kernelwillcrash when record and play in bf527-ezkit
>
>On Mon, Mar 09, 2009 at 06:58:19PM +0800, Cai, Cliff wrote:
>
>> This patch should be named : change the configuring way for sport, 
>> Because I found that the previous way is not reliable sometimes.
>> Application like "tone" ,will call starup() twice before entering
>> hw_params() to configure SPORT.  
>> in this case SPORT won't be configured at all.
>
>This doesn't address the concerns I raised with the patch:
>
>> >Won't this mean that if a second data format is played the 
>audio will 
>> >be mishandled since the hardware will not have been configured for 
>> >the new audio format?
>

I think I understand your concerns,I will send a new patch if I'm free.

Thanks

Cliff 
