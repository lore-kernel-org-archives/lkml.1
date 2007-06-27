Return-Path: <linux-kernel-owner+w=401wt.eu-S1763573AbXF0WOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763573AbXF0WOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 18:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760355AbXF0WO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 18:14:27 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:20171 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763453AbXF0WOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 18:14:25 -0400
Date: Thu, 28 Jun 2007 00:14:24 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Josh Triplett <josht@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       josh@kernel.org
Subject: Re: [PATCH] CodingStyle: Add information about trailing whitespace.
In-Reply-To: <20070627123122.257661e3.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706280012470.11120@fbirervta.pbzchgretzou.qr>
References: <1182967160.8970.108.camel@josh-work.beaverton.ibm.com>
 <20070627123122.257661e3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 27 2007 12:31, Andrew Morton wrote:
>
>quilt has ways of detecting and/or correcting newly-added trailing
>whitespace, but I don't know the details.

Upon `quilt ref`, it usually barfs about every line you touched where you
added or kept whitespace at EOL.

>One could share the various scriptlets which detect and fix trailing
>whitespace but I think this issue is getting less and less important
>now, because most maintainers will zap the new whitespace prior to
>merging.
>
><checks>
>But there's less than there used to be.

`| wc -l` it. The patches get larger, the # of patches declines :)


	Jan
-- 
