Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbYDEWzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbYDEWzh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 18:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbYDEWz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 18:55:28 -0400
Received: from flusers.ccur.com ([12.192.68.2]:55558 "EHLO flusers.ccur.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbYDEWz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 18:55:27 -0400
Date: Sat, 5 Apr 2008 18:54:44 -0400
From: Tom Horsley <tom.horsley@ccur.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Marc Pignat <marc.pignat@hevs.ch>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>
Subject: Re: module parameters versus kernel command line
Message-ID: <20080405185444.2c433673@tomh>
In-Reply-To: <200804050829.00418.rusty@rustcorp.com.au>
References: <20080403090053.56f243df@tomh>
	<200804040909.28983.rusty@rustcorp.com.au>
	<200804041345.38482.marc.pignat@hevs.ch>
	<200804050829.00418.rusty@rustcorp.com.au>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Apr 2008 08:29:00 +1000
Rusty Russell <rusty@rustcorp.com.au> wrote:

> I like this idea, and also have module tools ship with 
> a 'check-kernel-cmdline' tool which handles the warnings for unusable cmdline 
> params.  Distributions can run this in their init scripts, and we can remove 
> the warning from the kernel.

Or maybe not have the warning at all, after all, even if sillymodule.sillyarg=1
doesn't make sense when I booted, who's to say I can't download the source
to sillymodule, compile it, and modprobe it after boot time :-).
