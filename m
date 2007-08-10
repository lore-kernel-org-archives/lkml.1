Return-Path: <linux-kernel-owner+w=401wt.eu-S932333AbXHJSPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333AbXHJSPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 14:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbXHJSPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 14:15:39 -0400
Received: from mx1.suse.de ([195.135.220.2]:48719 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699AbXHJSPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 14:15:38 -0400
From: Andi Kleen <ak@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 3/4] Embed zone_id information within the zonelist->zones pointer
Date: Fri, 10 Aug 2007 20:13:48 +0200
User-Agent: KMail/1.9.1
Cc: Mel Gorman <mel@skynet.ie>, Lee.Schermerhorn@hp.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20070809210616.14702.73376.sendpatchset@skynet.skynet.ie> <20070810104749.GA14300@skynet.ie> <Pine.LNX.4.64.0708101035020.12758@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0708101035020.12758@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708102013.49170.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> x86_64 does not support ZONE_HIGHMEM.

I also plan to eliminate ZONE_DMA soon (and replace all its users
with a new allocator that sits outside the normal fallback lists) 

-Andi
