Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbYCLPH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbYCLPH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 11:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYCLPHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 11:07:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346AbYCLPHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 11:07:48 -0400
Date: Wed, 12 Mar 2008 08:05:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Jeff Garzik <jeff@garzik.org>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genhd must_check warning fix
In-Reply-To: <200803121507.39347.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.1.00.0803120803530.12341@woody.linux-foundation.org>
References: <20080312001317.D68A526F991@magilla.localdomain> <200803121440.26356.nickpiggin@yahoo.com.au> <47D753AC.8080206@garzik.org> <200803121507.39347.nickpiggin@yahoo.com.au>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 12 Mar 2008, Nick Piggin wrote:
> 
> If you tune out the must_check warnings, then how is that better than
> not having them at all? In either case, you'd have missed this genhd
> bug(let).

Quite frankly, there have historically been too many people who just added 
"must_check" to their function prototypes because they thought they were 
oh-so-important. Which means that at least _I_ tend to just ignore them 
(and have asked people to remove some when they get too annoying).

So I'm not at all surprised that people tune them out. They have become 
debased by being overused.

		Linus
