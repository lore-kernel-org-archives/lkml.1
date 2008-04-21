Return-Path: <linux-kernel-owner+w=401wt.eu-S1758020AbYDUSyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbYDUSyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 14:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbYDUSyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 14:54:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36017 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbYDUSyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 14:54:46 -0400
Subject: Re: [PATCH 1/2] OLPC: Add support for calling into Open Firmware
From: David Woodhouse <dwmw2@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andres Salomon <dilinger@queued.net>, Mitch Bradley <wmb@firmworks.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org,
       jordan.crouse@amd.com
In-Reply-To: <480CC78D.3000202@zytor.com>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
	 <20080419031024.GC3503@nineveh.local>
	 <20080418202925.b18452c5.akpm@linux-foundation.org>
	 <20080419092544.378664a8@ephemeral> <20080419133909.5aa6b63e@ephemeral>
	 <86802c440804200334t5cdcd100rfc41e9b1bf379109@mail.gmail.com>
	 <480C0582.9010509@firmworks.com>
	 <86802c440804202015h2605eff7vc733874dd1f22261@mail.gmail.com>
	 <480C1286.3040307@firmworks.com>  <20080421102417.6de71391@ephemeral>
	 <1208793253.9212.507.camel@pmac.infradead.org> <480CC78D.3000202@zytor.com>
Content-Type: text/plain
Date: Mon, 21 Apr 2008 19:54:04 +0100
Message-Id: <1208804044.9212.511.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-21 at 12:57 -0400, H. Peter Anvin wrote:
> David Woodhouse wrote:
> > 
> >> However, until we clean up the promfs stuff, there's no chance of getting
> >> an OFW device tree upstream.
> > 
> > I see no reason why we shouldn't be able to create a 'flattened'
> > device-tree during early boot, like the PowerPC kernel does. And use it
> > thereafter, having quiesced OpenFirmware. Haven't we already been
> > working on unifying this between SPARC and PowerPC kernels?
> > 
> > I definitely don't think we need to play these tricks to keep
> > OpenFirmware resident while the kernel is running. Take a look at your
> > second patch -- it's _all_ just lookups in the device-tree, and you're
> > inventing a new way to do it instead of using the existing one.
> > 
> 
> If so, would this apply to OLPC as well?

Yes. The 'second patch' to which I refer is the one which makes OLPC
platform code use the calls in OpenFirmware... all of them gratuitous.

-- 
dwmw2

