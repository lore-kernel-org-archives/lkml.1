Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbYIDOLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbYIDOLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 10:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYIDOLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 10:11:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:53164 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbYIDOLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 10:11:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Va6StdwGs721ZXdMMn2O4/MCZbPnLs3d+hHTzXwlYbhiQRcKFWqj3hKl3A4pynUKxm
         sbNmXEtfbq/fB7/6a5vyf78xnFYZQn2R0G73d8492dchkfle8DMbrQubGAi2fPyn2W6V
         dOtQveRlG4TCEr9PZF+poevdNOvpDxNp/gk7w=
Message-ID: <8bd0f97a0809040711k70a9784cu1f2dac31b23c978c@mail.gmail.com>
Date: Thu, 4 Sep 2008 10:11:39 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bryan Wu" <cooloney@kernel.org>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, "Cliff Cai" <cliff.cai@analog.com>
Subject: Re: [PATCH 3/9] ASoC: Blackfin: SPORT peripheral interface driver
In-Reply-To: <20080904104753.GC12775@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220516528-20301-1-git-send-email-cooloney@kernel.org>
	 <1220516528-20301-4-git-send-email-cooloney@kernel.org>
	 <20080904104753.GC12775@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2008 at 6:47 AM, Mark Brown wrote:
> On Thu, Sep 04, 2008 at 04:22:02PM +0800, Bryan Wu wrote:
>> From: Cliff Cai <cliff.cai@analog.com>
>
>> SPORT is a serial port which can support serveral serial communication protocols.
>> It can be used as I2C/PCM/AC97. For further information, please look up the HRM.
>
>> Signed-off-by: Cliff Cai <cliff.cai@analog.com>
>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>
> with the proviso that there's no ALSA or ASoC interfacing stuff in here
> so I'm likely to miss stuff.

yeah, this is like a library for our SPORT peripheral to avoid
duplicating it in all the Blackfin ALSA pieces
-mike
