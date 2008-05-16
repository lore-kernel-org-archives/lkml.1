Return-Path: <linux-kernel-owner+w=401wt.eu-S1760665AbYEPU1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760665AbYEPU1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 16:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbYEPU1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 16:27:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:34790 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbYEPU1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 16:27:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WPVdQ9AyyR6K807cM0mda5L39fvn4XcJEZ9wZNDhtxzioVmi7HCnBwGL0mbBqR5Eft1KT6/gT3kjt2W9NzbTCk/8vWu13yNbp9PtY862mouZbrmABweub7R2gTEhiMRggHcR/OUtV0+1HqS5+NyX0xtitrT7dRJ285WtUCy0YLI=
Message-ID: <9e4733910805161327u4c42fd1dg5b09319d89db447c@mail.gmail.com>
Date: Fri, 16 May 2008 16:27:33 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Grant Likely" <grant.likely@secretlab.ca>
Subject: Re: [RFC PATCH 0/4] Describe SPI devices in the OF device tree and add mpc5200-spi driver
Cc: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       fabrizio.garetto@gmail.com
In-Reply-To: <20080516193054.28030.35126.stgit@trillian.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/08, Grant Likely <grant.likely@secretlab.ca> wrote:
> This series is a set of changes to allow the slaves on an SPI bus to be
>  described in the OF device tree (useful in arch/powerpc) and adds a driver
>  that uses it (the Freescale MPC5200 SoC's SPI device).

Right now we have SPI hooked up to PSC3. Hardware engineer is gone but
I'll see if I can get him to alter things to use the SPI controller. I
have an old mail from him where he thinks the Phytec board is missing
a signal needed to use the SPI controller.

Is the current SPI driver working on PSC3? I have a MMC card wired up
to it but I've never tried using it.

I have the MPC5200 PSC SPI driver enabled and "MMC/SD over SPI"
enabled in my kernel. The MMC bus gets created but there aren't any
devices on it. Do we need something in the SPI driver so that the MMC
layer can find it?

Are you going to keeps this as two drivers or merge them? If it is two
drivers there should be one entry in Kconfig and two sub choices for
the types of drivers.

>  Please review and comment.  David, I've included in this series my earlier
>  patch to change modalias from a pointer to a string as one of the later
>  patches depends on it.
>
>  Cheers,
>  g.
>
>
>  --
>  Grant Likely, B.Sc. P.Eng.
>  Secret Lab Technologies Ltd.
>


-- 
Jon Smirl
jonsmirl@gmail.com
