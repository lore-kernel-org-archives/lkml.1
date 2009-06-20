Return-Path: <linux-kernel-owner+w=401wt.eu-S1752308AbZFTXMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbZFTXMf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 19:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbZFTXM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 19:12:28 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:48645 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbZFTXM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 19:12:27 -0400
X-IronPort-AV: E=Sophos;i="4.42,260,1243828800"; 
   d="scan'208";a="2847191"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: alsa-devel@alsa-project.org,
       "Mark Brown" <broonie@opensource.wolfsonmicro.com>
Subject: Re: [alsa-devel] [PATCH] New ASoC Drivers for ADI AD1938 codec
Date: Sat, 20 Jun 2009 19:15:39 -0400
User-Agent: KMail/1.9.5
CC: "Mike Frysinger" <vapier.adi@gmail.com>, "Barry Song" <21cnbao@gmail.com>,
       linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk
References: <1245403695-20537-1-git-send-email-21cnbao@gmail.com> <8bd0f97a0906190405k33503d8ekd74ec9ddbb2fde12@mail.gmail.com> <A40FAF28-889C-4322-A114-098EEA56FCE6@opensource.wolfsonmicro.com>
In-Reply-To: <A40FAF28-889C-4322-A114-098EEA56FCE6@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200906201915.39935.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 20 Jun 2009 23:12:29.0461 (UTC) FILETIME=[953CC450:01C9F1FC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 19 Jun 2009 07:13, Mark Brown pondered:
> On 19 Jun 2009, at 12:05, Mike Frysinger <vapier.adi@gmail.com> wrote:
> > On Fri, Jun 19, 2009 at 06:47, Mark Brown wrote:
> >> This will require that the arch code for any systems with the ad1938
> >> do the setup of the device.
> >
> > so should sound/soc/blackfin/bf5xx-ad1938.c even exist in the first  
> > place ?
> 
> Yes. It is needed in order to specify how things are hooked up on a  
> given board.

This has always kind of bugged me about ASOC - (or maybe it is just my 
ignorance about the architecture decisions that were made).

Any reason why platform/board specific things are in sound/soc/arch rather 
than arch/xxxx/boards - like the majority of drivers?

?

