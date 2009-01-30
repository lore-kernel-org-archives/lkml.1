Return-Path: <linux-kernel-owner+w=401wt.eu-S1758090AbZA3EiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbZA3EiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 23:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbZA3EiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 23:38:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751367AbZA3EiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 23:38:05 -0500
Date: Thu, 29 Jan 2009 20:37:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Risto Suominen <risto.suominen@gmail.com>, Alex Kern <alex.kern@gmx.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atyfb: fix distorted image on PowerMacs
Message-Id: <20090129203756.780aba28.akpm@linux-foundation.org>
In-Reply-To: <1233286970.18767.19.camel@pasglop>
References: <46e1c7760901221022p697f1689ubf03c909cdf1b99b@mail.gmail.com>
	<1233286970.18767.19.camel@pasglop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009 14:42:50 +1100 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Thu, 2009-01-22 at 20:22 +0200, Risto Suominen wrote:
> > Since the complete re-write in 2.6.10, some PowerMacs (At least PowerMac 5500
> > and PowerMac G3 Beige rev A) with ATI Mach64 chip have suffered from unstable
> > columns in their framebuffer image. This seems to depend on a value (4) read
> > from PLL_EXT_CNTL register, which leads to incorrect DSP config parameters to
> > be written to the chip. This patch uses a value calculated by aty_init_pll_ct
> > instead, as a starting point.
> > 
> > Signed-off-by: Risto Suominen <Risto.Suominen@gmail.com>
> > ---
> > The testing is done on kernel version 2.6.18.
> 
> This also fixes my oooold wallstreet powerbook.
> 
> Andrew, do you mind if I include that in the powerpc tree ?

Go wild.

Please don't to forget to add 'Cc: <stable@kernel.org>' to the changelog
if you consider a backport to be appropriate.
