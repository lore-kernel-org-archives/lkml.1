Return-Path: <linux-kernel-owner+w=401wt.eu-S932502AbZICXVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502AbZICXVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 19:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbZICXVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 19:21:38 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:38954 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299AbZICXVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 19:21:38 -0400
Date: Fri, 4 Sep 2009 00:21:39 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Question] x86,APIC: In apicdef.h dfr,svr,...... shouldn't be 
 const?
In-Reply-To: <b9df5fa10909031556i3d87ff72v3ce4ed8bcd4e5dd@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0909040019180.27310@eddie.linux-mips.org>
References: <b9df5fa10908312248x6a8946f5jfbe972f3358baad3@mail.gmail.com>  <alpine.LFD.2.00.0909020308510.27310@eddie.linux-mips.org> <b9df5fa10909031556i3d87ff72v3ce4ed8bcd4e5dd@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Sep 2009, Rakib Mullick wrote:

> >  All the three have meaningful semantics on writes at least on some
> >  versions of the APIC (they either have writable fields or trigger side
> >  effects on writes).  It looks like your documentation is wrong (not
> >  unheard of with Intel).
> 
> Thanks, Maciej. If my documentation is wrong, then which documentation
> should I follow? Isn't there any well defined document?

 You may have to track down an older revision of the document or that for 
an older CPU.  These registers may have changed as the architecture 
evolved and while Linux supports all the APIC versions, Intel may have 
omitted details for earlier implementations either deliberately or 
accidentally.

  Maciej
