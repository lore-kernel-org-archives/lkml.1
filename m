Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbYDUVSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbYDUVSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbYDUVSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:18:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54060 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbYDUVSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:18:05 -0400
Subject: Re: [PATCH] OLPC: only check for OFW signature on VSA-less Geodes
From: David Woodhouse <dwmw2@infradead.org>
To: Andres Salomon <dilinger@queued.net>
Cc: Mitch Bradley <wmb@firmworks.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org,
       jordan.crouse@amd.com
In-Reply-To: <20080421170230.2db18632@ephemeral>
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
	 <1208809517.9212.537.camel@pmac.infradead.org>
	 <20080421170230.2db18632@ephemeral>
Content-Type: text/plain
Date: Mon, 21 Apr 2008 22:17:51 +0100
Message-Id: <1208812671.7385.7.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-21 at 17:02 -0400, Andres Salomon wrote:
> The OFW sig check requires an ioremap that is dangerous on non-OLPC
> systems.  Long term, we should be getting the signature from the
> device tree (/openprom/model), but for right now just limit the
> check to only run on a subset of Geode (GX2/LX) systems.

That looks saner to me for now.

Acked-By: David Woodhouse <dwmw2@infradead.org>

-- 
dwmw2

