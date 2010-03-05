Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab0CEPsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 10:48:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55441
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752516Ab0CEPsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 10:48:17 -0500
Date: Fri, 05 Mar 2010 07:48:35 -0800 (PST)
Message-Id: <20100305.074835.159078083.davem@davemloft.net>
To: daniel@fooishbar.org
Cc: skeggsb@gmail.com, airlied@linux.ie, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, mingo@elte.hu,
       torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [git pull] drm request 3
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100305154009.GC2505@tempa>
References: <20100305151754.GB2505@tempa>
	<20100305.072612.186421758.davem@davemloft.net>
	<20100305154009.GC2505@tempa>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Stone <daniel@fooishbar.org>
Date: Fri, 5 Mar 2010 17:40:09 +0200

> On Fri, Mar 05, 2010 at 07:26:12AM -0800, David Miller wrote:
>> In fact, I argue that the moment nouveau went into Fedora and
>> was turned on by default, the interfaces needed to be frozen.
> 
> That's a matter for the Fedora kernel team; for better or worse, they
> made the choices they did, which included going through all the relevant
> pain to support this.  They didn't consider it suitable for upstream
> because they didn't think everyone else should be forced to endure that
> pain.

By not merging it upstream the pain is larger not smaller.

It's enabled by default, so you therefore can't test upstream kernels
by default.

And as I showed already, even if you jump through the hoops to make it
work (building noveau from out of tree in the upstream kernel) you'll
end up getting screwed when the API changes anyways.

Using VESA or whatever else you've suggested is just not a reasonable
alternative.

You can't unleash something like this on a userbase of this magnitude
and then throw your hands up in the air and say "I'm not willing to
support this in a reasonable way."

We're better than that.
