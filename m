Return-Path: <linux-kernel-owner+w=401wt.eu-S2993001AbXEBKZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993001AbXEBKZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 06:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993002AbXEBKZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 06:25:40 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:23650 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993001AbXEBKZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 06:25:39 -0400
From: Stefan Roese <ml@stefan-roese.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Correct location for ADC/DAC drivers
Date: Wed, 2 May 2007 12:25:53 +0200
User-Agent: KMail/1.9.5
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <200705011435.45046.ml@stefan-roese.de> <Pine.LNX.4.60.0705012301500.4972@poirot.grange>
In-Reply-To: <Pine.LNX.4.60.0705012301500.4972@poirot.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705021225.54417.ml@stefan-roese.de>
X-RZG-AUTH: j/Xgg0n2J5AIUJCkqLmy+bJbs1jMc+ebRMH8X0gX2f46QMnUI4cTITA7kWi4aT1d6CSX
X-RZG-CLASS-ID: mo00
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 May 2007 23:03, Guennadi Liakhovetski wrote:
> On Tue, 1 May 2007, Stefan Roese wrote:
> > I'm in the stage of integrating some ADC and DAC drivers for the AMCC
> > 405EZ PPC and looking for the correct location to place these drivers in
> > the Linux source tree. The drivers are basically character-drivers, so my
> > first thought is to put them in "drivers/char/adc/foo.c" or
> > "drivers/char/adc_foo.c". Is this a good solution?
>
> drivers/mfd following ucb1x00?

Perhaps. Not sure though. I just checked again and I still think the drivers 
will better fit for "our" drivers because of the chrdev nature.

Is there a maintainer for this "drivers/mfd" directory?

Thanks.

Best regards,
Stefan
