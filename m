Return-Path: <linux-kernel-owner+w=401wt.eu-S1764126AbXHQVHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764126AbXHQVHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 17:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756332AbXHQVHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 17:07:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47859 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754426AbXHQVHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 17:07:34 -0400
Date: Fri, 17 Aug 2007 14:07:33 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Lee.Schermerhorn@hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 6/6] Do not use FASTCALL for __alloc_pages_nodemask()
In-Reply-To: <20070817201848.14792.58117.sendpatchset@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0708171406520.9635@schroedinger.engr.sgi.com>
References: <20070817201647.14792.2690.sendpatchset@skynet.skynet.ie>
 <20070817201848.14792.58117.sendpatchset@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2007, Mel Gorman wrote:

> Opinions as to why FASTCALL breaks on one machine are welcome.

Could we get rid of FASTCALL? AFAIK the compiler should automatically 
choose the right calling convention?
