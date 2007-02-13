Return-Path: <linux-kernel-owner+w=401wt.eu-S1751014AbXBMRYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751014AbXBMRYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 12:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbXBMRYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 12:24:40 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:36731 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751068AbXBMRYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 12:24:39 -0500
Date: Tue, 13 Feb 2007 09:24:25 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       bob.picco@hp.com
Subject: Re: [RFC] [PATCH] more support for memory-less-node.
In-Reply-To: <200702130929.49349.andi@firstfloor.org>
Message-ID: <Pine.LNX.4.64.0702130923540.23752@schroedinger.engr.sgi.com>
References: <20070213155736.1131d46a.kamezawa.hiroyu@jp.fujitsu.com>
 <200702130929.49349.andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007, Andi Kleen wrote:

> The trouble with this is that you'll need to harden large parts
> of code against these.  Especially a NULL pgdat is something quite
> dangerous. You could make it a dummy empty pgdat, but just assigning it
> nearby seems easier.

Plus there is the issue of having a pgdat but without any valid zone in 
it. This is what triggered Kame-sans recent bug.

