Return-Path: <linux-kernel-owner+w=401wt.eu-S1752337AbYKNOLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbYKNOLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 09:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbYKNOLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 09:11:00 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:33866 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbYKNOK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 09:10:59 -0500
Subject: Re: [PATCH] revert: timers: fix itimer/many thread hang
From: Doug Chapman <doug.chapman@hp.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Frank Mayhar <fmayhar@google.com>,
       roland@redhat.com, adobriyan@gmail.com, akpm@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20081113160808.GA13726@elte.hu>
References: <1224694989.8431.23.camel@oberon>
	 <1225132746.14792.13.camel@bobble.smo.corp.google.com>
	 <1225219114.24204.37.camel@oberon>
	 <1225936715.27507.44.camel@bobble.smo.corp.google.com>
	 <1225969420.7803.4366.camel@twins> <1225989102.7803.4749.camel@twins>
	 <1226592021.21297.25.camel@oberon>  <20081113160808.GA13726@elte.hu>
Content-Type: text/plain
Date: Fri, 14 Nov 2008 09:10:51 -0500
Message-Id: <1226671851.21297.34.camel@oberon>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-11-13 at 17:08 +0100, Ingo Molnar wrote:
> * Doug Chapman <doug.chapman@hp.com> wrote:
> 
> > Peter didn't mention here that the itimer/many thread patches cause 
> > a race-condition panic which is easily reproduced (in fact 
> > unavoidable with SLUB debugging on) on hyperthreaded ia64 systems 
> > (but certainly possible on all systems).  Can we get this revert 
> > patch pulled in?  The other attempts to fix this so far have been 
> > unsuccessful.  I have tested with this revert patch and it does 
> > indeed fix that issue.
> 
> Could you please try with the very latest upstream kernel? It should 
> be fixed by Oleg's fix patch via:
> 
> ad474ca: fix for account_group_exec_runtime(), make sure ->signal can't be fre
> 
> which is already upstream.
> 
> 	Ingo

Ingo,

Thanks, somehow I had missed that.  I tested with the latest GIT tree
and the issue is resolved now.

- Doug


