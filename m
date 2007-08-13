Return-Path: <linux-kernel-owner+w=401wt.eu-S1764400AbXHMXMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764400AbXHMXMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 19:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756407AbXHMXMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 19:12:19 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54805 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756784AbXHMXMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 19:12:18 -0400
Date: Mon, 13 Aug 2007 16:12:17 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: Mel Gorman <mel@skynet.ie>, Lee.Schermerhorn@hp.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] Embed zone_id information within the zonelist->zones
 pointer
In-Reply-To: <20070813235518.GK3406@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0708131611001.19910@schroedinger.engr.sgi.com>
References: <200708110304.55433.ak@suse.de> <Pine.LNX.4.64.0708131423050.28026@schroedinger.engr.sgi.com>
 <20070813225020.GE3406@bingen.suse.de> <Pine.LNX.4.64.0708131457190.28445@schroedinger.engr.sgi.com>
 <20070813225841.GG3406@bingen.suse.de> <Pine.LNX.4.64.0708131506030.28502@schroedinger.engr.sgi.com>
 <20070813230801.GH3406@bingen.suse.de> <Pine.LNX.4.64.0708131518320.28626@schroedinger.engr.sgi.com>
 <20070813234217.GI3406@bingen.suse.de> <Pine.LNX.4.64.0708131550100.30626@schroedinger.engr.sgi.com>
 <20070813235518.GK3406@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007, Andi Kleen wrote:

> > What would be the point?
> 
> "so that drivers not need to ifdef" 

But they use GFP_DMA right now and drivers cannot use DMA32 if they want 
to be cross platforms compatible? Doesnt the dma API completely do away 
with these things?

