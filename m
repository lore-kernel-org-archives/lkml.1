Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbZDPUzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbZDPUzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 16:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754470AbZDPUzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 16:55:11 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:35944 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbZDPUzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 16:55:10 -0400
Date: Thu, 16 Apr 2009 15:55:03 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, dave@linux.vnet.ibm.com, mingo@elte.hu,
       orenl@cs.columbia.edu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/30] cr: deal with nsproxy
Message-ID: <20090416205503.GA28928@us.ibm.com>
References: <20090410023809.GT27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410023809.GT27788@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> To save nsproxy, or to not save nsproxy?
> 
> Don't think much, save it.
> 
> I argue that nsproxy should be removed totally, if someone thinks otherwise. ;-)

You've got Oren starting to agree with you too.  I personally don't
much care in principle, and your code looks very nice.

The way you do this and the uts patch, though, you (of course) bypass
the CAP_SYS_ADMIN check in copy_namespaces().  Which is fine for your
patchset, but a problem if we were to base a compromise patchset on
your patchset.

It of course also enforces the 'leakage' checks, which again is
subject to our whole-container c/r discussion.

But again, the code is nice, and I see no problems in it.

-serge
