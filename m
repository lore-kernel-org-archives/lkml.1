Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbYDVUbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbYDVUbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbYDVUay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:30:54 -0400
Received: from relay2.sgi.com ([192.48.171.30]:48151 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751122AbYDVUay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:30:54 -0400
Date: Tue, 22 Apr 2008 13:30:53 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Robin Holt <holt@sgi.com>
cc: Andrea Arcangeli <andrea@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       Jack Steiner <steiner@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 00 of 12] mmu notifier #v13
In-Reply-To: <20080422194223.GT22493@sgi.com>
Message-ID: <Pine.LNX.4.64.0804221328400.3640@schroedinger.engr.sgi.com>
References: <patchbomb.1208872276@duo.random> <20080422182213.GS22493@sgi.com>
 <20080422184335.GN24536@duo.random> <20080422194223.GT22493@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2008, Robin Holt wrote:

> putting it back into your patch/agreeing to it remaining in Andrea's
> patch?  If not, I think we can put this issue aside until Andrew gets
> out of the merge window and can decide it.  Either way, the patches
> become much more similar with this in.

One solution would be to separate the invalidate_page() callout into a
patch at the very end that can be omitted. AFACIT There is no compelling 
reason to have this callback and it complicates the API for the device 
driver writers. Not having this callback makes the way that mmu notifiers 
are called from the VM uniform which is a desirable goal.


