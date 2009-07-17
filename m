Return-Path: <linux-kernel-owner+w=401wt.eu-S933852AbZGQAWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933852AbZGQAWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933734AbZGQAWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:22:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:35126 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933715AbZGQAWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:22:43 -0400
Subject: Re: [PATCH 1/2] vga: implements VGA arbitration on Linux
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Tiago Vignatti <tiago.vignatti@nokia.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Dave Airlie <airlied@redhat.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <21d7e9970907160338o50ede093pbef32f2d7d351f41@mail.gmail.com>
References: <1247576250-16274-1-git-send-email-tiago.vignatti@nokia.com>
	 <1247576250-16274-2-git-send-email-tiago.vignatti@nokia.com>
	 <20090714153509.51bbec27@lxorguk.ukuu.org.uk>
	 <21d7e9970907152125i52dc3f4dqd540f7d65667cfb5@mail.gmail.com>
	 <20090716094855.455c3f77@lxorguk.ukuu.org.uk>
	 <21d7e9970907160338o50ede093pbef32f2d7d351f41@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 17 Jul 2009 10:22:15 +1000
Message-Id: <1247790135.27937.73.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 20:38 +1000, Dave Airlie wrote:
> Oops yes I want to avoid doing anything except VGA resources on/off
> I don't think the granularity matters, will talk to BenH tomorrow see
> what his original idea was.

Well, it's more than VGA on/off... if your card decodes VGA, then it's
all memory (or IO) resources on/off...

I -think- it may be that I split memory and IO with the idea that DRM
mostly don't need IO for irqs etc... and so we could technically steal
only IO for some things, like VGA based mode switching on the other
card, without disturbing the guy next door.

Cheers,
Ben.


