Return-Path: <linux-kernel-owner+w=401wt.eu-S1765359AbXF1UUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765359AbXF1UUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 16:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759927AbXF1UUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 16:20:47 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:55815 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758843AbXF1UUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 16:20:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=XPNoFsHVZrKKBY4rvq7s6ze0SooiQdaw0+7p21aUbRkbBttXDDWh9JmCACUOkLvEw/OW8Zo+iBOSMyxy346SsOsPtqy00J7cpFhg/g9L06UyixWoqHWYl7XM+e1S+a8Y20AUF3XhDWJYXdyRNVLOTdWeTfHGg4YWN13sCcu6Ic0=
Message-ID: <75b66ecd0706281320s29178c8brec8c3ef6b7fe7e7b@mail.gmail.com>
Date: Thu, 28 Jun 2007 16:20:45 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Cc: Nix <nix@esperi.org.uk>, "Adrian Bunk" <bunk@stusta.de>,
       "Olivier Galibert" <galibert@pobox.com>, "Takashi Iwai" <tiwai@suse.de>,
       "Tomasz K?oczko" <kloczek@rudy.mif.pg.gda.pl>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <468413D2.60101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl>
	 <20070624215724.025a5de5@the-village.bc.nu>
	 <Pine.BSO.4.63.0706251052380.25800@rudy.mif.pg.gda.pl>
	 <s5h3b0gi9mp.wl%tiwai@suse.de>
	 <Pine.BSO.4.63.0706251308020.25800@rudy.mif.pg.gda.pl>
	 <s5hzm2ogqr7.wl%tiwai@suse.de>
	 <20070625124442.GA44019@dspnet.fr.eu.org>
	 <20070625132107.GD1094@stusta.de> <87tzssextf.fsf@hades.wkstn.nix>
	 <468413D2.60101@gmail.com>
X-Google-Sender-Auth: b55ef0d8be628676
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/28/07, Rene Herman <rene.herman@gmail.com> wrote:
> ALSA has been the Linux soundsystem for a number of years now and as such,
> an application that runs under Linux and produces sound more and more can be
> expected to do so using the Linux API. The only reason it _can_ be seen as a
> detail is due to the Just Works nature of the OSS emulation but that is
> changing due to the software mixing. Binary apps are also moving to ALSA
> currently, ie, flash, skype, ...

If your disto ships with any OSS apps using the in-kernel emulation
you should file a bug report, as it results in bizarre and undesirable
behavior - a single app opening /dev/dsp will block audio for every
other app (OSS or ALSA) on the vast majority of hardware out there.

Lee
