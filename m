Return-Path: <linux-kernel-owner+w=401wt.eu-S1757187AbYEMC67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbYEMC67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 22:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbYEMC6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 22:58:51 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:35052 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbYEMC6u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 22:58:50 -0400
X-IronPort-AV: E=Sophos;i="4.27,476,1204520400"; 
   d="scan'208";a="53437923"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/1] [ASOC]: AD1980 audio codec ASOC driver
Date: Tue, 13 May 2008 11:00:58 +0800
Message-ID: <0F1B54C89D5F954D8535DB252AF412FA01F2EF2C@chinexm1.ad.analog.com>
In-Reply-To: <20080512115416.GB23216@sirena.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] [ASOC]: AD1980 audio codec ASOC driver
Thread-Index: Aci0Ju1N3iQJsIoPRuymd96jkhq2bwAfiWYg
References: <1210589112-12208-1-git-send-email-cooloney@kernel.org> <20080512115416.GB23216@sirena.org.uk>
From: "Cai, Cliff" <Cliff.Cai@analog.com>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
       "Bryan Wu" <cooloney@kernel.org>
Cc: <liam.girdwood@wolfsonmicro.com>, <linux-kernel@vger.kernel.org>,
       <alsa-devel@alsa-project.org>
X-OriginalArrivalTime: 13 May 2008 02:58:47.0639 (UTC) FILETIME=[43934E70:01C8B4A5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 ok,we will implement these two functions later.

Best Regards
Cliff Cai

-----Original Message-----
From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com] 
Sent: Monday, May 12, 2008 7:54 PM
To: Bryan Wu
Cc: liam.girdwood@wolfsonmicro.com; linux-kernel@vger.kernel.org; Cliff
Cai; alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/1] [ASOC]: AD1980 audio codec ASOC driver

On Mon, May 12, 2008 at 06:45:12PM +0800, Bryan Wu wrote:
> From: Cliff Cai <cliff.cai@analog.com>
> 
> Signed-off-by: Cliff Cai <cliff.cai@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Thanks, I've applied this to the ASoC git tree.  CCing in
alsa-devel@alsa-project.org - ALSA patches should go via there.

> +static int ad1980_soc_suspend(struct platform_device *pdev,
> +	pm_message_t state)
> +{
> +	return 0;
> +}
> +
> +static int ad1980_soc_resume(struct platform_device *pdev) {
> +	return 0;
> +}

Are you sure about these?  I would expect the suspend and resume
functions to either do some register writes or be omitted if they don't
do anything.  Standard AC97 codecs would have some power management via
register 0x26 if they were doing anything.
