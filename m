Return-Path: <linux-kernel-owner+w=401wt.eu-S1761817AbZFKOql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761817AbZFKOql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 10:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbZFKOqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 10:46:35 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:62752 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbZFKOqe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 10:46:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gRVVL06iK932QW7Kkm4uzH1K4sszT3rYqAf3yivEXFOgZ7OVh+BT/mDgVQpmGol0hp
         nTMv2+0iOqAokoHrdNw69FQXwWYT0xpRO8Ge2dqzqsFodvvGptkC1yjDt+za5N1FgDnx
         AIEGmdBpcfQ6ETrK4+jv+zUBNmJ26/3xt1XnM=
MIME-Version: 1.0
Reply-To: Tobias_Mueller@twam.info
In-Reply-To: <20090610001033.27b7f69f@mycelium.queued.net>
References: <20090610001033.27b7f69f@mycelium.queued.net>
Date: Thu, 11 Jun 2009 16:46:35 +0200
X-Google-Sender-Auth: a4bb78b434e0cf9f
Message-ID: <17be05570906110746l214f88cdh8570488e1be51b30@mail.gmail.com>
Subject: Re: [PATCH 1/2] cs5535-gpio: add AMD CS5535/CS5536 GPIO driver 
	support
From: =?UTF-8?Q?Tobias_M=C3=BCller?= <Tobias_Mueller@twam.info>
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: akpm@linux-foundation.org, Randy Dunlap <randy.dunlap@oracle.com>,
       deepak@laptop.org, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org, linux-geode@lists.infradead.org,
       jordan@cosmicpenguin.net, cjb@laptop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/10 Andres Salomon <dilinger@collabora.co.uk>:
> +config GPIO_CS5535
> +       tristate "AMD CS5535/CS5536 GPIO support"
> +       depends on PCI && !CS5535_GPIO && !MGEODE_LX
> +       help
> +         The AMD CS5535 and CS5536 southbridges support 28 GPIO pins that
> +         can be used for quite a number of things.  The CS5535/6 is found on
> +         AMD Geode and Lemote Yeeloong devices.

Why do you depend on !MGEODE_LX? Are there any problems?
