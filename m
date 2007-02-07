Return-Path: <linux-kernel-owner+w=401wt.eu-S1161085AbXBGIEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161085AbXBGIEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 03:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161097AbXBGIEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 03:04:47 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:51190 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161085AbXBGIEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 03:04:47 -0500
Date: Wed, 7 Feb 2007 00:04:41 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com, clameter@engr.sgi.com,
       akpm@osdl.org
Subject: Re: [2.6.20][PATCH] fix mempolicy error check on a system with
 memory-less-node
In-Reply-To: <20070207101400.feda1bf9.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0702070002430.2188@schroedinger.engr.sgi.com>
References: <20070206202312.4f979bcf.kamezawa.hiroyu@jp.fujitsu.com>
 <Pine.LNX.4.64.0702060925130.9812@schroedinger.engr.sgi.com>
 <20070207101400.feda1bf9.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007, KAMEZAWA Hiroyuki wrote:

> > Hmmm... Remove the node from the node_online_map instead?
> > 
> Changing defintion of node_online_map is harmfil. (there are cpu-only-nodes.)
> How about adding  nodemask for nodes equips memory ?

Ok that is better but...

Would it be possible to attach the cpus to the 
next nodes with memory and mark the node offline? That way we could avoid 
another mask that we constantly have to check?

Or fix the location where the error occurred to be able to tolerate a node 
with no zones?

