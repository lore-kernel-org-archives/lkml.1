Return-Path: <linux-kernel-owner+w=401wt.eu-S1750930AbXBXFro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750930AbXBXFro (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 00:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbXBXFrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 00:47:43 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39799 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750889AbXBXFrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 00:47:43 -0500
Date: Fri, 23 Feb 2007 21:47:36 -0800 (PST)
From: Christoph Lameter <clameter@engr.sgi.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: andi@firstfloor.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: SLUB: The unqueued Slab allocator
In-Reply-To: <20070224142835.4c7a3207.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0702232145340.1872@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702212250271.30485@schroedinger.engr.sgi.com>
 <p73hctecc3l.fsf@bingen.suse.de> <Pine.LNX.4.64.0702221040140.2011@schroedinger.engr.sgi.com>
 <20070224142835.4c7a3207.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Feb 2007, KAMEZAWA Hiroyuki wrote:

> >From a viewpoint of a crash dump user, this merging will make crash dump
> investigation very very very difficult.

The general caches already merge lots of users depending on their sizes. 
So we already have the situation and we have tools to deal with it.
