Return-Path: <linux-kernel-owner+w=401wt.eu-S1752480AbYJSBHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbYJSBHU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 21:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbYJSBHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 21:07:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:34222 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbYJSBHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 21:07:07 -0400
Date: Sat, 18 Oct 2008 18:06:51 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Keith Packard <keithp@keithp.com>
Cc: Ingo Molnar <mingo@elte.hu>, keithp@keithp.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sf.net, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [git pull] drm patches for 2.6.27-rc1
Message-ID: <20081018180651.11b1d4a8@infradead.org>
In-Reply-To: <1224376691.4384.105.camel@koto.keithp.com>
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>
	<200810181237.49784.nickpiggin@yahoo.com.au>
	<1224357062.4384.72.camel@koto.keithp.com>
	<alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
	<20081018203741.GA23396@elte.hu>
	<1224366690.4384.89.camel@koto.keithp.com>
	<20081018223214.GA5093@elte.hu>
	<1224376691.4384.105.camel@koto.keithp.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Oct 2008 17:38:11 -0700
Keith Packard <keithp@keithp.com> wrote:

> I've got Venki lined up to do this work for me; once we're happy
> enough with the API. In particular, the non-highmem 32-bit case seems
> a bit tricky.
> 
> Also, does anyone have a better set of names for this stuff?
> io_reserve_pci_mapping seems fairly ugly to me.
> 

how about pci_resource_force_caching(pci_dev, barnr, cachetype)?

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
