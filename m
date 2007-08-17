Return-Path: <linux-kernel-owner+w=401wt.eu-S1764688AbXHQVDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764688AbXHQVDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 17:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757483AbXHQVDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 17:03:46 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47641 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754370AbXHQVDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 17:03:46 -0400
Date: Fri, 17 Aug 2007 14:03:45 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Lee.Schermerhorn@hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 4/6] Record how many zones can be safely skipped in the
 zonelist
In-Reply-To: <20070817201808.14792.13501.sendpatchset@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0708171402540.9635@schroedinger.engr.sgi.com>
References: <20070817201647.14792.2690.sendpatchset@skynet.skynet.ie>
 <20070817201808.14792.13501.sendpatchset@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any performance improvement because of this patch? It looks 
like processing got more expensive since an additional cacheline needs to 
be fetches to get the skip factor.

