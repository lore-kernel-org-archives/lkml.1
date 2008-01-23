Return-Path: <linux-kernel-owner+w=401wt.eu-S1752675AbYAWIkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbYAWIkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 03:40:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751071AbYAWIjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 03:39:55 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:55420 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbYAWIjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 03:39:54 -0500
Date: Wed, 23 Jan 2008 09:40:16 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       hanth Aravamudan <nacc@us.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       lee.schermerhorn@hp.com, Linux MM <linux-mm@kvack.org>,
       akpm@linux-foundation.org
Subject: Re: crash in kmem_cache_init
Message-ID: <20080123084016.GA17911@aepfle.de>
References: <20080118225713.GA31128@aepfle.de> <20080122195448.GA15567@csn.ul.ie> <Pine.LNX.4.64.0801221203340.27950@schroedinger.engr.sgi.com> <20080122212654.GB15567@csn.ul.ie> <Pine.LNX.4.64.0801221330390.1652@schroedinger.engr.sgi.com> <20080122225046.GA866@csn.ul.ie> <47967560.8080101@cs.helsinki.fi> <Pine.LNX.4.64.0801221501240.2565@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0801221517260.2871@schroedinger.engr.sgi.com> <84144f020801230019i5ac6c8b1lfa5364672988b0c4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <84144f020801230019i5ac6c8b1lfa5364672988b0c4@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, Pekka Enberg wrote:

> Hi Christoph,
> 
> On Jan 23, 2008 1:18 AM, Christoph Lameter <clameter@sgi.com> wrote:
> > My patch is useless (fascinating history of the changelog there through).
> > fallback_alloc calls kmem_getpages without GFP_THISNODE. This means that
> > alloc_pages_node() will try to allocate on the current node but fallback
> > to neighboring node if nothing is there....
> 
> Sure, but I was referring to the scenario where current node _has_
> pages available but no ->nodelists. Olaf, did you try it?

Does not help.
