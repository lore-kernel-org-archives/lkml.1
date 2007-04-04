Return-Path: <linux-kernel-owner+w=401wt.eu-S2992972AbXDDP4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992972AbXDDP4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 11:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992977AbXDDP4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 11:56:41 -0400
Received: from mail.suse.de ([195.135.220.2]:59619 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992972AbXDDP4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 11:56:41 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch 04/17] Add pagetable accessors to pack and unpack pagetable entries
Date: Wed, 4 Apr 2007 17:56:34 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <20070402055652.610711908@goop.org> <200704041347.42822.ak@suse.de> <4613C828.2030604@goop.org>
In-Reply-To: <4613C828.2030604@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704041756.35016.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 April 2007 17:45:44 Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> > Why is there a difference for null syscall? I had assumed we patched all the 
> > fast path cases relevant there. Do you have an idea where it comes from?
> 
> Sure.  There's indirect calls for things like sti/cli/iret.  It goes
> back to native speed when you patch the real instructions inline.

I was talking about the patched case. It seemed to be a little slower
too, but in theory it shouldn't have been, no? 

-Andi

