Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab0AODgX (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 22:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332Ab0AODgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 22:36:22 -0500
Received: from gate.crashing.org ([63.228.1.57]:41346 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116Ab0AODgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 22:36:22 -0500
Subject: Re: drm/radeon/kms: fix up LVDS handling on macs (v2)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc: Alex Deucher <alexdeucher@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>
In-Reply-To: <1263463781.3544.4714.camel@thor>
References: <201001140059.o0E0x4wS006650@hera.kernel.org>
	 <1263437142.724.320.camel@pasglop>  <1263463781.3544.4714.camel@thor>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jan 2010 14:35:56 +1100
Message-ID: <1263526556.724.402.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-14 at 11:09 +0100, Michel Dänzer wrote:
> I have looked at radeonfb for a patch I posted a while ago to expose a
> backlight class device with KMS, and I can only see what you describe
> above affecting the LVDS_GEN_CNTL backlight level, not BLON or
> BL_MOD_EN. Am I missing something?

No, you aren't, it's radeonfb who is :-) I never quite got that part
right. I was somewhat hoping several times that Hui and then Alex would
manage to dig some info from ATI about what the right method is to drive
those panels I think :-)

But my observation on those HW was definitely that when inverted,
disabling the modulation was also turning the panel to full bright on,
rather than turning it off.

> Without my patch, KMS doesn't change the backlight level at all, so
> assuming the firmware manages to enable the backlight, it should stay
> like that.

Your patch might make things better than they are today, I'm not arguing
there :-) I'm just saying that now might be a good time to try to sort
out exactly what should be done in there :-)

Cheers,
Ben.

