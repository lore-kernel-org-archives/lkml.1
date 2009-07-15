Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbZGOIfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbZGOIfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 04:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbZGOIfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 04:35:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58142 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752855AbZGOIfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 04:35:23 -0400
Date: Wed, 15 Jul 2009 09:35:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Takashi Iwai <tiwai@suse.de>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: sound tree build warning
Message-ID: <20090715083521.GB8689@rakim.wolfsonmicro.main>
References: <20090715131354.da512c72.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090715131354.da512c72.sfr@canb.auug.org.au>
X-Cookie: Use other side for additional listings.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 01:13:54PM +1000, Stephen Rothwell wrote:

> Today's linux-next build (x86_64 allmodconfig) produced this warning:

That's one of the configurations I regularly test build but I've not
seen this - which compiler are you using?  Might be worth reporting that
along with warnings.

> sound/soc/codecs/wm8993.c: In function 'wm8993_hw_params':
> sound/soc/codecs/wm8993.c:1799: warning: array subscript is above array bounds

Fixed, though Takashi seems to be away at the minute so it'll not appear
in -next until he reappears.
