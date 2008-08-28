Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbYH1KOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbYH1KOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 06:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYH1KOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 06:14:38 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4011 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbYH1KOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 06:14:38 -0400
Date: Thu, 28 Aug 2008 11:14:35 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Bryan Wu <cooloney@kernel.org>
Cc: perex@perex.cz, lrg@kernel.org, Cliff Cai <cliff.cai@analog.com>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 3/4] ASOC: WM8731 codec: add SPI support as well as I2C
Message-ID: <20080828101434.GB11132@sirena.org.uk>
Mail-Followup-To: Bryan Wu <cooloney@kernel.org>, perex@perex.cz,
	lrg@kernel.org, Cliff Cai <cliff.cai@analog.com>,
	alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
References: <1219829968-6431-1-git-send-email-cooloney@kernel.org> <1219829968-6431-4-git-send-email-cooloney@kernel.org> <20080827110143.GB10834@sirena.org.uk> <386072610808272046u270c1302g1102bf1f0bd9b6ee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <386072610808272046u270c1302g1102bf1f0bd9b6ee@mail.gmail.com>
X-Cookie: To see you is to sympathize.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 11:46:24AM +0800, Bryan Wu wrote:
> On Wed, Aug 27, 2008 at 7:01 PM, Mark Brown <broonie@sirena.org.uk> wrote:

> > ...as for the SSM2602 it'd be good if it were possible to build a kernel
> > which supports both I2C and SPI.  If you like I could do this for you -
> > there's likely to be merge issues due to the update to the new I2C API
> > anyway?

> Oh, do you mean SSM2602 or WM8731? I also noticed the i2c API updates
> patch from Jean and I'd like to use the new one

Sorry, that could've been clearer - I meant wm8731.  Obviously if you
want to update that too then that would be great but I figured it'd make
life easier for you if I were to ensure that one gets merged OK.  Which
way do you prefer?
