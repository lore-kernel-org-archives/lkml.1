Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbXJILHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbXJILHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 07:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbXJILHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 07:07:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:50350 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbXJILHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 07:07:14 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH for 2.6.23] Fix scheduler domain sysctl list
Date: Tue, 9 Oct 2007 13:07:04 +0200
User-Agent: KMail/1.9.6
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <20071009100224.GA22834@wotan.suse.de> <20071009102632.GB15583@elte.hu>
In-Reply-To: <20071009102632.GB15583@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710091307.04653.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 October 2007 12:26:32 Ingo Molnar wrote:
> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> > Ingo has this already fixed in sched-devel (but he also adds more 
> > parameters here). Since the fix is very simple I think it should be 
> > fixed for .23. Especially cache_nice_tries is useful to tune because 
> > it is very magic and the current values are a little dubious.
> 
> this is a debug feature so i'll do a backport of this fix for 2.6.23.1, 

Ok.

> once sched-devel.git goes into .24.

It's very debuggish -- e.g. no ENOMEM checking at all.

-Andi

