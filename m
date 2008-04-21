Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbYDUTSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbYDUTSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbYDUTSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:18:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39534 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbYDUTSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:18:40 -0400
Subject: Re: [PATCH 1/2] OLPC: Add support for calling into Open Firmware
From: David Woodhouse <dwmw2@infradead.org>
To: Andres Salomon <dilinger@queued.net>
Cc: Mitch Bradley <wmb@firmworks.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org,
       jordan.crouse@amd.com
In-Reply-To: <20080421130320.38b5f505@ephemeral>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
	 <20080419031024.GC3503@nineveh.local>
	 <20080418202925.b18452c5.akpm@linux-foundation.org>
	 <20080419092544.378664a8@ephemeral> <20080419133909.5aa6b63e@ephemeral>
	 <86802c440804200334t5cdcd100rfc41e9b1bf379109@mail.gmail.com>
	 <480C0582.9010509@firmworks.com>
	 <86802c440804202015h2605eff7vc733874dd1f22261@mail.gmail.com>
	 <480C1286.3040307@firmworks.com> <20080421102417.6de71391@ephemeral>
	 <1208793253.9212.507.camel@pmac.infradead.org>
	 <20080421130320.38b5f505@ephemeral>
Content-Type: text/plain
Date: Mon, 21 Apr 2008 20:18:11 +0100
Message-Id: <1208805491.9212.520.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-21 at 13:03 -0400, Andres Salomon wrote:
> Quite simply, it's a lot more work (*and* we have to play nice w/
> sparc and ppc).  

It's only more work because we did it the wrong way in the first place.
If only someone had pointed it out at the time... :)

For interaction with device-tree properties in generic code, you should
be using the functions defined in <linux/of.h>.

Creating the static device-tree before we quiesce OpenFirmware surely
shouldn't be so hard? Can't we cut and paste most of that code anyway?

> I had intended to eventually do it, but first I wanted
> to get this stuff in for 2.6.26 so that we could at least boot upstream
> kernels on XOs.

Is it only the things in your second patch which need to be made to
work? One of them was already working, by grubbing around in the BIOS
directly -- so all we need is the board revision, isn't it? Can we get
that from the EC for now?

-- 
dwmw2

