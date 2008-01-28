Return-Path: <linux-kernel-owner+w=401wt.eu-S1761423AbYA1TEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761423AbYA1TEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbYA1TEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:04:46 -0500
Received: from relay2.sgi.com ([192.48.171.30]:43842 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751784AbYA1TEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:04:45 -0500
Date: Mon, 28 Jan 2008 11:04:43 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Izik Eidus <izike@qumranet.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 0/4] [RFC] MMU Notifiers V1
In-Reply-To: <20080128172521.GC7233@v2.random>
Message-ID: <Pine.LNX.4.64.0801281103030.14003@schroedinger.engr.sgi.com>
References: <20080125055606.102986685@sgi.com> <20080125114229.GA7454@v2.random>
 <479DFE7F.9030305@qumranet.com> <20080128172521.GC7233@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008, Andrea Arcangeli wrote:

> So I'd like to know what can we do to help to merge the 4 patches from
> Christoph in mainline, I'd appreciate comments on them so we can help
> to address any outstanding issue!

There are still some pending issues (RCU troubles). I will post V2 today.
 
> It's very important to have this code in 2.6.25 final. KVM requires
> mmu notifiers for reliable swapping, madvise/ballooning, ksm etc... so
> it's high priority to get something merged to provide this
> functionality regardless of its coding style ;).

We also need this urgently.
