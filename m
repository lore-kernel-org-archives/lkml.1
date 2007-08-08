Return-Path: <linux-kernel-owner+w=401wt.eu-S936545AbXHHRiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936545AbXHHRiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbXHHRiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:38:16 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36890 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752719AbXHHRiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:38:14 -0400
Date: Wed, 8 Aug 2007 10:38:13 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Lee.Schermerhorn@hp.com, pj@sgi.com, ak@suse.de,
       kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] Use zonelists instead of zones when direct reclaiming
 pages
In-Reply-To: <20070808161524.32320.87008.sendpatchset@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0708081037450.12652@schroedinger.engr.sgi.com>
References: <20070808161504.32320.79576.sendpatchset@skynet.skynet.ie>
 <20070808161524.32320.87008.sendpatchset@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Good idea. Maybe it could be taken further by passing the zonelist also 
into shrink_zones()?


