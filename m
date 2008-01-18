Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbYARG4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbYARG4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 01:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbYARG4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 01:56:12 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:37395 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbYARG4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 01:56:11 -0500
Date: Fri, 18 Jan 2008 07:56:21 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Linux MM <linux-mm@kvack.org>
Subject: Re: crash in kmem_cache_init
Message-ID: <20080118065621.GA27495@aepfle.de>
References: <20080115150949.GA14089@aepfle.de> <84144f020801170414q7d408a74uf47a84b777c36a4a@mail.gmail.com> <Pine.LNX.4.64.0801170628580.19208@schroedinger.engr.sgi.com> <20080117181222.GA24411@aepfle.de> <Pine.LNX.4.64.0801171049190.21058@schroedinger.engr.sgi.com> <20080117211511.GA25320@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080117211511.GA25320@aepfle.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, Olaf Hering wrote:

> On Thu, Jan 17, Christoph Lameter wrote:
> 
> > On Thu, 17 Jan 2008, Olaf Hering wrote:
> > 
> > > The patch does not help.
> > 
> > Duh. We need to know more about the problem.
> 
> cache_grow is called from 3 places. The third call has cleared l3 for
> some reason.

Typo in debug patch.

calls cache_grow with nodeid 0
> [c00000000075bbd0] [c0000000000f82d0] .cache_alloc_refill+0x234/0x2c0
calls cache_grow with nodeid 0
> [c00000000075bbe0] [c0000000000f7f38] .____cache_alloc_node+0x17c/0x1e8

calls cache_grow with nodeid 1
> [c00000000075bbe0] [c0000000000f7d68] .fallback_alloc+0x1a0/0x1f4

