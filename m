Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803Ab0AZVrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab0AZVrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 16:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680Ab0AZVrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 16:47:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754729Ab0AZVrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 16:47:17 -0500
Date: Tue, 26 Jan 2010 13:46:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Sascha linux-arm <s.hauer@pengutronix.de>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Dan Williams <dan.j.williams@intel.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mx3fb: some debug and initialisation fixes.
Message-Id: <20100126134657.4cc543a6.akpm@linux-foundation.org>
In-Reply-To: <1263999434.3083.44.camel@realization>
References: <1263999434.3083.44.camel@realization>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010 15:57:14 +0100
Alberto Panizzo <maramaopercheseimorto@gmail.com> wrote:

> Fix the kernel oops when dev_dbg is called with mx3_fbi->txd == NULL
> 
> Fix the late initialisation of mx3fb->backlight_level.
> If not, in the chain of function started by init_fb_chan(), in __blank() call 
> sdc_set_brightness(mx3fb, mx3fb->backlight_level) that will shut down
> the CONTRAST PWM output. 

I guess these aren't the biggest bugs we ever had but I tagged the
patch for backporting into 2.6.32.x anyway - the fixes are prety
obvious.

Your email client replaces tabs with spaces.  I fixed that up, but
please do prevent it from happening next time. 
Documentation/email-clients.txt has some Evolution tips.

