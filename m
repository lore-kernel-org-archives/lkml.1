Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876Ab0A0Jp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab0A0Jp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 04:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818Ab0A0Jp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 04:45:29 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34897 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab0A0Jp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 04:45:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mrHJPsXGQLpsQy5MPIQVbOwvjxKkq3al1Iu+egGq3FJaweeePF6LgBTfkNTItPl5BQ
         sft+V8m5WOmIK6EO2n232FilfxcSbg+0g68uyw787Ek1JVx+wWdqkCfsU2mwhRF2LwC6
         +OkodygCuW2qsdP+IsReN8jUDWlOgPl1hGNKU=
Subject: Re: [PATCH] mx3fb: some debug and initialisation fixes.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sascha linux-arm <s.hauer@pengutronix.de>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Dan Williams <dan.j.williams@intel.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100126134657.4cc543a6.akpm@linux-foundation.org>
References: <1263999434.3083.44.camel@realization>
	 <20100126134657.4cc543a6.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jan 2010 10:45:21 +0100
Message-ID: <1264585521.2463.15.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On mar, 2010-01-26 at 13:46 -0800, Andrew Morton wrote:
> On Wed, 20 Jan 2010 15:57:14 +0100
> Alberto Panizzo <maramaopercheseimorto@gmail.com> wrote:
> 
> > Fix the kernel oops when dev_dbg is called with mx3_fbi->txd == NULL
> > 
> > Fix the late initialisation of mx3fb->backlight_level.
> > If not, in the chain of function started by init_fb_chan(), in __blank() call 
> > sdc_set_brightness(mx3fb, mx3fb->backlight_level) that will shut down
> > the CONTRAST PWM output. 
> 
> I guess these aren't the biggest bugs we ever had but I tagged the
> patch for backporting into 2.6.32.x anyway - the fixes are prety
> obvious.

Yes, apart of the debug part, the late initialisation of 
mx3fb->backlight_level prevent screen switch-on on boot in my development
board. So for me (and for all hardware that make use of the CONTRAST PWM to
control the brightness) is important.

> 
> Your email client replaces tabs with spaces.  I fixed that up, but
> please do prevent it from happening next time. 
> Documentation/email-clients.txt has some Evolution tips.
> 

The Evolution client lose tabs in copy/past between mails....
I'll take more care on this in future.

Thanks!

Alberto!


