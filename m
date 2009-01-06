Return-Path: <linux-kernel-owner+w=401wt.eu-S1755077AbZAFWmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbZAFWmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761990AbZAFWlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:41:25 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:24565 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761978AbZAFWlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:41:23 -0500
X-IronPort-AV: E=Sophos;i="4.37,222,1231131600"; 
   d="scan'208";a="80717834"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
Date: Tue, 6 Jan 2009 17:41:12 -0500
User-Agent: KMail/1.9.5
Cc: "David Brownell" <david-b@pacbell.net>,
       "Eric Miao" <eric.y.miao@gmail.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Eric Miao" <eric.miao@marvell.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Philipp Zabel" <philipp.zabel@gmail.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Ben Gardner" <bgardner@wabtec.com>, "Greg KH" <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com> <200812311238.13810.rgetz@blackfin.uclinux.org> <45a44e480812311005k709c410ao1116187e9427e452@mail.gmail.com>
In-Reply-To: <45a44e480812311005k709c410ao1116187e9427e452@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901061741.12410.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 06 Jan 2009 22:41:00.0620 (UTC) FILETIME=[D93DC0C0:01C9704F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 31 Dec 2008 13:05, Jaya Kumar pondered:
> On Thu, Jan 1, 2009 at 1:38 AM, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> > On Tue 30 Dec 2008 23:58, Jaya Kumar pondered:
> >> On Tue, Dec 30, 2008 at 11:55 PM, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> >> > Yeah, I hadn't thought about spanning more than one gpio_chip. That's a good
> >> > point.
> >>
> >> The currently posted code already supports spanning more than one gpio_chip.
> >>
> >
> > But doesn't do all the other things that David suggested/requested.
> 
> Hi Robin,
> 
> Yes, you are right. My implementation does not support a driver that
> needs to set/get more than 32-bits of gpio in a single call. I'm okay
> with that restriction as I don't see a concrete use case for that.

It's not the more than 32-bits that I'm concerned about - it is spanning
more than one register. (if all the GPIOs that are left on the board are 
2, 64, and 128, where 2, and 64 are part of the SOC's GPIO, and 128 is on
a GPIO expander - which is a common use case - is this handled?)
