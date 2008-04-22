Return-Path: <linux-kernel-owner+w=401wt.eu-S933550AbYDVWoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933550AbYDVWoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760263AbYDVWoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:44:05 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:34325
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758970AbYDVWoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:44:04 -0400
Date: Wed, 23 Apr 2008 00:43:52 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <npiggin@suse.de>, Jack Steiner <steiner@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>, akpm@linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 02 of 12] Fix ia64 compilation failure because of
	common code include bug
Message-ID: <20080422224352.GS24536@duo.random>
References: <3c804dca25b15017b220.1208872278@duo.random> <Pine.LNX.4.64.0804221319430.3640@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804221319430.3640@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 01:22:55PM -0700, Christoph Lameter wrote:
> Looks like this is not complete. There are numerous .h files missing which 
> means that various structs are undefined (fs.h and rmap.h are needed 
> f.e.) which leads to surprises when dereferencing fields of these struct.
> 
> It seems that mm_types.h is expected to be included only in certain 
> contexts. Could you make sure to include all necessary .h files? Or add
> some docs to clarify the situation here.

Robin, what other changes did you need to compile? I only did that one
because I didn't hear any more feedback from you after I sent that
patch, so I assumed it was enough.
