Return-Path: <linux-kernel-owner+w=401wt.eu-S1752959AbYCHXTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbYCHXTd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 18:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbYCHXTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 18:19:24 -0500
Received: from mx1.suse.de ([195.135.220.2]:34902 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbYCHXTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 18:19:23 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch -mm 2/2] mempolicy: use default_policy mode instead of MPOL_DEFAULT
Date: Sun, 9 Mar 2008 00:19:19 +0100
User-Agent: KMail/1.9.6
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Paul Jackson <pj@sgi.com>,
       akpm@linux-foundation.org, clameter@sgi.com,
       linux-kernel@vger.kernel.org
References: <alpine.DEB.1.00.0803071720460.4611@chino.kir.corp.google.com> <1205003580.4918.21.camel@localhost> <alpine.DEB.1.00.0803081414460.12095@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.00.0803081414460.12095@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803090019.19518.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Using MPOL_DEFAULT purely for falling back to the task or system-wide 
> policy, however, seems confusing.  The semantics seem to indicate that 
> MPOL_DEFAULT represents the system-wide default policy without any 
> preferred node or set of nodes to bind or interleave.  So if a VMA has a 
> policy of MPOL_DEFAULT then, to me, it seems like that indicates the 
> absence of a specific policy, not a mandate to fallback to the task 
> policy.

I designed MPOL_DEFAULT on vma originally to be a fallback to the task policy.

Absence of specific policy would be MPOL_PREFERRED with -1 node.

-Andi



