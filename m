Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbYLJSdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbYLJSdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756547AbYLJS2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:28:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756534AbYLJS2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:28:32 -0500
Date: Wed, 10 Dec 2008 10:27:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       Eric Anholt <eric@anholt.net>
Subject: Re: Bug in i915 GEM module
Message-Id: <20081210102749.fa39877c.akpm@linux-foundation.org>
In-Reply-To: <20081208190235.GA4498@ics.muni.cz>
References: <20081208190235.GA4498@ics.muni.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Dec 2008 20:02:35 +0100 Lukas Hejtmanek <xhejtman@ics.muni.cz> wrote:

> I'm trying to use UXA acceleration method and when browsing with firefox on
> web galeries, I got the following error:
> [24166.963712] [drm:i915_gem_object_bind_to_gtt] *ERROR* GTT full, but LRU list empty
> [24166.963724] [drm:i915_gem_object_pin] *ERROR* Failure to bind: -12<3>[drm:i915_gem_evict_something] *ERROR* inactive empty 1 request empty 1 flushing empty 1
> [24166.971734] ------------[ cut here ]------------
> [24166.971739] kernel BUG at drivers/gpu/drm/i915/i915_gem.c:2211!

Eric tells me "The main kernel bug here is already fixed in the code
Linus just pulled.  There's a little bugfix for the error path to avoid
triggering the BUG, which could happen after the main fix if we lost a
race for a signal."

So please retest Linus's current git tree, thanks.
