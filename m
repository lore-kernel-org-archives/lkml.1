Return-Path: <linux-kernel-owner+w=401wt.eu-S1754253AbZEDLhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbZEDLhH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 07:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbZEDLgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 07:36:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56725 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbZEDLgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 07:36:52 -0400
Date: Mon, 4 May 2009 13:37:52 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Kwangwoo Lee <kwangwoo.lee@gmail.com>
Cc: Trilok Soni <soni.trilok@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] input: Add support for the TSC2003 controller.
Message-ID: <20090504113751.GA22603@avionic-design.de>
References: <1241006627-22811-1-git-send-email-thierry.reding@avionic-design.de> <5d5443650904290623n3712cd7dja653a139cff2cf6d@mail.gmail.com> <483a38b80904291835p51044741p9bd83d33a40031c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483a38b80904291835p51044741p9bd83d33a40031c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Provags-ID: V01U2FsdGVkX1+pRCVkshR4jWSWDa28N9yK6MSESw22qpaz3nh
 x9vlvFx81OwSV9D06RZOPWgO88HVvpwgxwY+IYqf1MkwMKOD31
 z1gSbPzkNOlJntaTyitFQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kwangwoo Lee wrote:
> Hi Thierry and Trilok,
> 
> On Wed, Apr 29, 2009 at 10:23 PM, Trilok Soni <soni.trilok@gmail.com> wrote:
> > Hi Thierry,
> >
> > I have added linux-omap community. How different is this chip from
> > tsc2007. It looks to me that this chip is not much different from
> > tsc2007 (this is just quick look at the driver). If they
> > are similar please consider using i2c_device_id feature in tsc2007 to
> > accommodate this chip.
> 
> I agree with the Trilok's opinion.
[snip]

I only noticed the tsc2007 driver some time ago, when the tsc2003 was already
finished (it's actually pretty old, I just never got around to submitting
it). However I never got the tsc2007 to work on my platform because it uses
sleeping functions inside the timer handler, which results in an oops right
after the first touchscreen interrupt.

I guess I could try and fix the tsc2007 properly instead of having a second,
pretty similar driver in the tree.

Cheers,
Thierry

