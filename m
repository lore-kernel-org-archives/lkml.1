Return-Path: <linux-kernel-owner+w=401wt.eu-S1946266AbXBPV2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946266AbXBPV2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 16:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946269AbXBPV2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 16:28:50 -0500
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:36893 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946266AbXBPV2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 16:28:49 -0500
Date: Fri, 16 Feb 2007 16:28:47 -0500 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Christoph Lameter <clameter@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@engr.sgi.com>
Subject: Re: 2.6.20-mm1 [kernel BUG at mm/swap.c:442]
In-Reply-To: <Pine.LNX.4.64.0702160756020.23808@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0702161628320.5602@d.namei>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0702150926560.25081@d.namei> <20070215135157.18085ae3.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0702160938300.2581@d.namei> <Pine.LNX.4.64.0702160756020.23808@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007, Christoph Lameter wrote:

> Andrew already has this fix which cures it for me. PG_mlocked pages can 
> be freed in some situations and thus we need the correct handling in the 
> page allocator:

Works for me.


- James
-- 
James Morris
<jmorris@namei.org>
