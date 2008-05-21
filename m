Return-Path: <linux-kernel-owner+w=401wt.eu-S1764109AbYEUB4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764109AbYEUB4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 21:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756169AbYEUB4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 21:56:13 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54704 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753878AbYEUB4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 21:56:12 -0400
Date: Tue, 20 May 2008 18:56:09 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
cc: David Chinner <dgc@sgi.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, andi@firstfloor.org,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       mpm@selenic.com
Subject: Re: [patch 10/21] buffer heads: Support slab defrag
In-Reply-To: <20080520232256.GA16105@2ka.mipt.ru>
Message-ID: <Pine.LNX.4.64.0805201854080.12560@schroedinger.engr.sgi.com>
References: <20080512002403.GP103491721@sgi.com>
 <Pine.LNX.4.64.0805151041230.18708@schroedinger.engr.sgi.com>
 <20080515231045.GY155679365@sgi.com> <Pine.LNX.4.64.0805161000390.29603@schroedinger.engr.sgi.com>
 <20080519054554.GY103491721@sgi.com> <Pine.LNX.4.64.0805190942530.18431@schroedinger.engr.sgi.com>
 <20080520002503.GC173056135@sgi.com> <20080520065622.GA13968@2ka.mipt.ru>
 <20080520214617.GU103491721@sgi.com> <20080520222505.GA23988@2ka.mipt.ru>
 <20080520232256.GA16105@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008, Evgeniy Polyakov wrote:

> Cristoph, is this example you wnated to check out? It will only try to
> write .nr_to_write pages between .range_start and .range_end without
> syncing inode info itself.

Well that is what Dave wants. I'd rather go the safe route for now and 
defer this until later. I think you are much more an expert on the 
filesystems and I/O paths than I am. So I'd rather take my hands of as 
soon as possible.

