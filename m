Return-Path: <linux-kernel-owner+w=401wt.eu-S1759942AbYAHOll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759942AbYAHOll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 09:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758879AbYAHOlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 09:41:32 -0500
Received: from there.is.no.cabal.ca ([134.117.69.58]:59473 "EHLO
	fattire.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbYAHOlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 09:41:32 -0500
Date: Tue, 8 Jan 2008 09:41:30 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] call sysrq_timer_list_show from a workqueue
Message-ID: <20080108144130.GB21287@fattire.cabal.ca>
References: <20080108063113.GA21287@fattire.cabal.ca> <20080108091742.GD27671@elte.hu> <200801082228.05218.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801082228.05218.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 10:28:04PM +1100, Rusty Russell wrote:
> De-mutex more symbol lookup paths in the module code
> 
> Kyle McMartin reports sysrq_timer_list_show() can hit the module
> mutex; these paths don't need to though, since we long ago changed all
> the module list manipulation to occur via stop_machine().
> 
> Disabling preemption is enough.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 

ACK that it (obviously) fixes the lock checker spew.

Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>

cheers, Kyle
