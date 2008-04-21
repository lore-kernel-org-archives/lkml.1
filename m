Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbYDUUZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbYDUUZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 16:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755369AbYDUUZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 16:25:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53823 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbYDUUZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 16:25:42 -0400
Subject: Re: [PATCH 1/2] OLPC: Add support for calling into Open Firmware
From: David Woodhouse <dwmw2@infradead.org>
To: Andres Salomon <dilinger@queued.net>
Cc: Mitch Bradley <wmb@firmworks.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org,
       jordan.crouse@amd.com
In-Reply-To: <20080421154618.2ed4978f@ephemeral>
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
	 <1208805491.9212.520.camel@pmac.infradead.org>
	 <20080421154618.2ed4978f@ephemeral>
Content-Type: text/plain
Date: Mon, 21 Apr 2008 21:25:17 +0100
Message-Id: <1208809517.9212.537.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-21 at 15:46 -0400, Andres Salomon wrote:
> Well, no, it wasn't already working; that's the reason this whole
> thread started.  It was crashing someone's machine.  That's why the OFW
> interface, as imperfect as it is, is an _improvement_.

You're proposing a new interface between bootloader and kernel as a
temporary hack just to work around that until we fix it properly?

That seems like overkill to me. I'd just go for is_geode() as you
suggested, and maybe PCI configuration tricks to detect the lack of VSA
so we can be _fairly_ sure it's OLPC before we poke at it?

Or why not try '!page_is_ram(0xffffffc0 >> PAGE_SHIFT)' if it's just to
avoid that particular warning? :)

-- 
dwmw2

