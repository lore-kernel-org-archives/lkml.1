Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbZCKC5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbZCKC5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 22:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbZCKC4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 22:56:54 -0400
Received: from mail2.shareable.org ([80.68.89.115]:36804 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbZCKC4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 22:56:54 -0400
Date: Wed, 11 Mar 2009 02:56:36 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Kyle McMartin <kyle@infradead.org>
Cc: airlied@redhat.com, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, jbarnes@virtuousgeek.org,
       marko.ristola@kolumbus.fi
Subject: Re: [PATCH] drm: edid revision 0 is valid
Message-ID: <20090311025636.GA31718@shareable.org>
References: <20090225013153.GC6690@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225013153.GC6690@bombadil.infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin wrote:
> -	if (edid->revision <= 0 || edid->revision > 3) {
> +	if (edid->revision > 3) {
>  		DRM_ERROR("EDID has minor version %d, which is not between 0-3\n", edid->revision);
>  		goto bad;

Ahem.  EDID version 1.4 exists too, in fact it's the current version.
EDID 1.5+ doesn't exist, but it should be backward compatible when it does.

I'm doing a lot of work on another EDID parser, including full DMT and
CEA-861 mode tables, monitor hotplug, all quirks from Xorg and the
kernel, EDID 1.4 support w/ CVT calculation, etc. right now for an
embedded Linux video project.  Would there be any interest
incorporating parts of that work?

-- Jamie
