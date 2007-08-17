Return-Path: <linux-kernel-owner+w=401wt.eu-S1764771AbXHQVCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764771AbXHQVCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 17:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686AbXHQVCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 17:02:05 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58410 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754552AbXHQVCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 17:02:04 -0400
Date: Fri, 17 Aug 2007 14:02:01 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Lee.Schermerhorn@hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 3/6] Embed zone_id information within the zonelist->zones
 pointer
In-Reply-To: <20070817201748.14792.37660.sendpatchset@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0708171400570.9635@schroedinger.engr.sgi.com>
References: <20070817201647.14792.2690.sendpatchset@skynet.skynet.ie>
 <20070817201748.14792.37660.sendpatchset@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2007, Mel Gorman wrote:

> +/*
> + * SMP will align zones to a large boundary so the zone ID will fit in the
> + * least significant biuts. Otherwise, ZONES_SHIFT must be 2 or less to
> + * fit

ZONES_SHIFT is always 2 or less....

Acked-by: Christoph Lameter <clameter@sgi.com>
