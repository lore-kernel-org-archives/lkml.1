Return-Path: <linux-kernel-owner+w=401wt.eu-S1753243AbYAWAk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbYAWAk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 19:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbYAWAkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 19:40:52 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53463 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750906AbYAWAkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 19:40:51 -0500
Date: Tue, 22 Jan 2008 16:40:50 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Andrea Arcangeli <andrea@qumranet.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, Andrew Morton <akpm@osdl.org>,
       Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, holt@sgi.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [kvm-devel] [PATCH] export notifier #1
In-Reply-To: <1201044989.6807.46.camel@pasglop>
Message-ID: <Pine.LNX.4.64.0801221640010.3329@schroedinger.engr.sgi.com>
References: <20080113162418.GE8736@v2.random>  <20080116124256.44033d48@bree.surriel.com>
 <478E4356.7030303@qumranet.com>  <20080117162302.GI7170@v2.random>
 <478F9C9C.7070500@qumranet.com>  <20080117193252.GC24131@v2.random>
 <20080121125204.GJ6970@v2.random>  <4795F9D2.1050503@qumranet.com>
 <20080122144332.GE7331@v2.random>  <20080122200858.GB15848@v2.random> 
 <Pine.LNX.4.64.0801221232040.28197@schroedinger.engr.sgi.com>
 <1201044989.6807.46.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jan 2008, Benjamin Herrenschmidt wrote:

> > - anon_vma/inode and pte locks are held during callbacks.
> 
> So how does that fix the problem of sleeping then ?

The locks are taken in the mmu_ops patch. This patch does not hold them 
while performing the callbacks.

