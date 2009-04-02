Return-Path: <linux-kernel-owner+w=401wt.eu-S1763411AbZDBTaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763411AbZDBTaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 15:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933356AbZDBTaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 15:30:20 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:34283 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762846AbZDBTaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 15:30:19 -0400
Date: Thu, 2 Apr 2009 20:27:21 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Rusty Russell <rusty@rustcorp.com.au>,
       virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       akpm@osdl.org, frankeh@watson.ibm.com, riel@redhat.com
Subject: Re: [patch 0/6] Guest page hinting version 7.
In-Reply-To: <20090402175249.3c4a6d59@skybase>
Message-ID: <Pine.LNX.4.64.0904022016180.29625@blonde.anvils>
References: <20090327150905.819861420@de.ibm.com> <200903281705.29798.rusty@rustcorp.com.au>
 <20090329162336.7c0700e9@skybase> <200904022232.02185.nickpiggin@yahoo.com.au>
 <20090402175249.3c4a6d59@skybase>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009, Martin Schwidefsky wrote:
> On Thu, 2 Apr 2009 22:32:00 +1100
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> > I still think this needs much more justification.
>  
> Ok, I can understand that. We probably need a KVM based version to show
> that benefits exist on non-s390 hardware as well.

That would indeed help your cause enormously (I think I made the same
point last time).  All these complex transitions, added to benefit only
an architecture to which few developers have access, asks for trouble -
we mm hackers already get caught out often enough by your
too-well-camouflaged page_test_dirty().

Hugh
