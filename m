Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbYDWSJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbYDWSJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 14:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbYDWSJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 14:09:38 -0400
Received: from relay1.sgi.com ([192.48.171.29]:55512 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752810AbYDWSJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 14:09:37 -0400
Date: Wed, 23 Apr 2008 11:09:35 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Robin Holt <holt@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Jack Steiner <steiner@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 01 of 12] Core of mmu notifiers
In-Reply-To: <20080423155940.GY24536@duo.random>
Message-ID: <Pine.LNX.4.64.0804231105090.12373@schroedinger.engr.sgi.com>
References: <ea87c15371b1bd49380c.1208872277@duo.random>
 <Pine.LNX.4.64.0804221315160.3640@schroedinger.engr.sgi.com>
 <20080422223545.GP24536@duo.random> <20080422230727.GR30298@sgi.com>
 <20080423133619.GV24536@duo.random> <20080423144747.GU30298@sgi.com>
 <20080423155940.GY24536@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2008, Andrea Arcangeli wrote:

> Implement unregister but it's not reliable, only ->release is reliable.

Why is there still the hlist stuff being used for the mmu notifier list? 
And why is this still unsafe?

There are cases in which you do not take the reverse map locks or mmap_sem
while traversing the notifier list?

This hope for inclusion without proper review (first for .25 now for .26) 
seems to interfere with the patch cleanup work and cause delay after delay 
for getting the patch ready. On what basis do you think that there is a 
chance of any of these patches making it into 2.6.26 given that this 
patchset has never been vetted in Andrew's tree?



