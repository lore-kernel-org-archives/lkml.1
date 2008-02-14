Return-Path: <linux-kernel-owner+w=401wt.eu-S933412AbYBNOc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933412AbYBNOc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 09:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755247AbYBNOcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 09:32:48 -0500
Received: from pip13.gyao.ne.jp ([61.122.117.251]:34345 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755022AbYBNOcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 09:32:47 -0500
Date: Thu, 14 Feb 2008 23:31:24 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] markers: Fix build for MODULES=n.
Message-ID: <20080214143124.GA14777@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>
References: <20080214072517.GG12436@linux-sh.org> <20080214133244.GB27478@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214133244.GB27478@Krystal>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 08:32:44AM -0500, Mathieu Desnoyers wrote:
> * Paul Mundt (lethal@linux-sh.org) wrote:
> >   CC      kernel/marker.o
> > kernel/marker.c: In function 'marker_update_probes':
> > kernel/marker.c:627: error: too few arguments to function 'module_update_markers'
> > make[1]: *** [kernel/marker.o] Error 1
> > make: *** [kernel] Error 2
> > 
> > module_update_markers() doesn't take any arguments, update the MODULES=n
> > version of it to reflect that.
> > 
> 
> Hi Paul, thanks for submitting this. Adrian-the-roadrunner has been
> faster than you though. :) He already submitted this fix here :
> 
> http://lkml.org/lkml/2008/2/13/714
> 
No worries, I was just tossing out stuff I hit with my randconfigs now
that things are slowing down. It's difficult to verify your own stuff
when the rest of the tree keeps breaking. It's good to know there are
other people doing similar tests ;-)
