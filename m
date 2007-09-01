Return-Path: <linux-kernel-owner+w=401wt.eu-S1752219AbXIAAek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbXIAAek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 20:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbXIAAed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 20:34:33 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49276 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751160AbXIAAec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 20:34:32 -0400
Date: Fri, 31 Aug 2007 17:34:31 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Lee.Schermerhorn@hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 5/6] Use one zonelist that is filtered by nodemask
In-Reply-To: <20070831205319.22283.45590.sendpatchset@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0708311732580.19868@schroedinger.engr.sgi.com>
References: <20070831205139.22283.71284.sendpatchset@skynet.skynet.ie>
 <20070831205319.22283.45590.sendpatchset@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Good idea. That gets rid of the GFP_THISNODE stuff that I introduced for 
the memoryless node patchset.


