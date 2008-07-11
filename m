Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbYGKGno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbYGKGno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 02:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbYGKGnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 02:43:35 -0400
Received: from ozlabs.org ([203.10.76.45]:60336 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853AbYGKGnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 02:43:35 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH -next-20080709] fixup stop_machine use cpu mask vs ftrace
Date: Fri, 11 Jul 2008 16:43:29 +1000
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@redhat.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
References: <200807081801.38026.rusty@rustcorp.com.au> <200807081756.47140.rusty@rustcorp.com.au> <for-27-patch0-1@bga.com>
In-Reply-To: <for-27-patch0-1@bga.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807111643.30233.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 July 2008 07:07:57 Milton Miller wrote:
> Hi Rusty, Ingo.
>
> Rusty's patch [PATCH 3/3] stop_machine: use cpu mask rather than magic
> numbers didn't find kernel/trace/ftrace.c in -next, causing an immediate
> almost NULL pointer dereference in ftrace_dynamic_init.

Yes, I'm switching the patches around, so it does the transition correctly. 
Introduces a new stop_machine() fn with the new interface and deprecates the 
old stop_machine_run().  We can remove stop_machine_run() after everyone is 
switched.

Thanks,
Rusty.
