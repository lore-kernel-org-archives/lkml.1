Return-Path: <linux-kernel-owner+w=401wt.eu-S1761815AbXEPAub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761815AbXEPAub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 20:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760190AbXEPAuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 20:50:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54170 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759977AbXEPAuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 20:50:23 -0400
Date: Tue, 15 May 2007 17:50:22 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: mroos@linux.ee, David Miller <davem@davemloft.net>,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: slab hang on boot
In-Reply-To: <20070515165636.5057456e.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705151748210.4272@schroedinger.engr.sgi.com>
References: <Pine.SOC.4.64.0705142133190.17204@math>
 <20070514.151148.45744375.davem@davemloft.net>
 <Pine.LNX.4.64.0705141642350.13606@schroedinger.engr.sgi.com>
 <20070515163321.744e2388.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705151642530.3886@schroedinger.engr.sgi.com>
 <20070515165636.5057456e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007, Andrew Morton wrote:

> Either that newly-added test isn't needed, or those ifdefs aren't needed?

The #ifdefs dont do the proper job thus the hack for Dave. The following 
RFC will clean things up.

http://marc.info/?l=linux-kernel&m=117919444827939&w=2

