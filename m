Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbZDEFcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbZDEFcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 01:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbZDEFcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 01:32:06 -0400
Received: from ozlabs.org ([203.10.76.45]:48578 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282AbZDEFcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 01:32:05 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] - Fix slab corruption caused by alloc_cpumask_var_node()
Date: Sun, 5 Apr 2009 15:01:53 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.27-11-generic; KDE/4.2.2; i686; ; )
Cc: Jack Steiner <steiner@sgi.com>, akpm@linux-foundation.org,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org
References: <20090402212751.GA11495@sgi.com> <20090402214219.GC21070@elte.hu>
In-Reply-To: <20090402214219.GC21070@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904051501.54190.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 April 2009 08:12:19 Ingo Molnar wrote:
> 
> * Jack Steiner <steiner@sgi.com> wrote:
> 
> > Fix for slab corruption caused by alloc_cpumask_var_node() overwriting
> > the tail end of an off-stack cpumask.

Ouch.  Thanks for this!

And I see it's already in Linus' tree while I was away, thanks all!
Rusty.
