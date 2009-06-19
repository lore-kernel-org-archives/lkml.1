Return-Path: <linux-kernel-owner+w=401wt.eu-S1760600AbZFSL67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760600AbZFSL67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 07:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758363AbZFSL43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 07:56:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58562 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759400AbZFSL42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 07:56:28 -0400
References: <1245403695-20537-1-git-send-email-21cnbao@gmail.com>  <20090619104738.GF5270@sirena.org.uk> <8bd0f97a0906190405k33503d8ekd74ec9ddbb2fde12@mail.gmail.com>  <A40FAF28-889C-4322-A114-098EEA56FCE6@opensource.wolfsonmicro.com> <8bd0f97a0906190421q332f337cr1799c6b65bd06f0e@mail.gmail.com> (sfid-20090619_122210_786837_40A5C757)
Message-Id: <FD8E5377-D9B2-4876-8A82-F2E29BA3B2E4@opensource.wolfsonmicro.com>
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Frysinger <vapier.adi@gmail.com>
In-Reply-To: <8bd0f97a0906190421q332f337cr1799c6b65bd06f0e@mail.gmail.com> (sfid-20090619_122210_786837_40A5C757)
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7A341)
Mime-Version: 1.0 (iPhone Mail 7A341)
Subject: Re: [PATCH] New ASoC Drivers for ADI AD1938 codec
Date: Fri, 19 Jun 2009 12:56:13 +0100
Cc: Barry Song <21cnbao@gmail.com>,
       "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 Jun 2009, at 12:21, Mike Frysinger <vapier.adi@gmail.com> wrote:

> On Fri, Jun 19, 2009 at 07:13, Mark Brown wrote:
>>>>
>>>
>>>
>>
>>>>
>>>>
>>>
>> Yes. It is needed in order to specify how things are hooked up on a  
>> given
>> board.
>
> to look at the wm8731 then, these are good examples of how it's done ?
> sound/soc/atmel/sam9g20_wm8731.c
> sound/soc/pxa/corgi.c

Anything should be OK - possibly one of the existing Blackfin drivers.  
I mentioned wm8731 due to the SPI but by the time it gets to the  
machine driver that's hidden so it's not urgently relevant.
