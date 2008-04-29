Return-Path: <linux-kernel-owner+w=401wt.eu-S1756165AbYD2DH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbYD2DH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 23:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbYD2DHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 23:07:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752342AbYD2DHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 23:07:15 -0400
Date: Mon, 28 Apr 2008 20:06:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andres Salomon <dilinger@queued.net>
Cc: David Woodhouse <dwmw2@infradead.org>, Mitch Bradley <wmb@firmworks.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Joseph Fannin <jfannin@gmail.com>,
       linux-kernel@vger.kernel.org, jordan.crouse@amd.com
Subject: Re: [PATCH] OLPC: only check for OFW signature on VSA-less Geodes
Message-Id: <20080428200651.169f1db1.akpm@linux-foundation.org>
In-Reply-To: <20080421170230.2db18632@ephemeral>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
	<20080419031024.GC3503@nineveh.local>
	<20080418202925.b18452c5.akpm@linux-foundation.org>
	<20080419092544.378664a8@ephemeral>
	<20080419133909.5aa6b63e@ephemeral>
	<86802c440804200334t5cdcd100rfc41e9b1bf379109@mail.gmail.com>
	<480C0582.9010509@firmworks.com>
	<86802c440804202015h2605eff7vc733874dd1f22261@mail.gmail.com>
	<480C1286.3040307@firmworks.com>
	<20080421102417.6de71391@ephemeral>
	<1208793253.9212.507.camel@pmac.infradead.org>
	<20080421130320.38b5f505@ephemeral>
	<1208805491.9212.520.camel@pmac.infradead.org>
	<20080421154618.2ed4978f@ephemeral>
	<1208809517.9212.537.camel@pmac.infradead.org>
	<20080421170230.2db18632@ephemeral>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Apr 2008 17:02:30 -0400 Andres Salomon <dilinger@queued.net> wrote:

> +	if (!is_geode() || geode_has_vsa2())

geode_has_vsa2() is a fairly expensive-looking function and afacit only
needs to be evaluated once per boot.  Perhaps we should cache it somewhere?

