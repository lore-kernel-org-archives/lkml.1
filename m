Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbYDFDI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbYDFDI6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 23:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbYDFDIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 23:08:51 -0400
Received: from ozlabs.org ([203.10.76.45]:38828 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598AbYDFDIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 23:08:50 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tom Horsley <tom.horsley@ccur.com>
Subject: Re: module parameters versus kernel command line
Date: Sun, 6 Apr 2008 13:08:30 +1000
User-Agent: KMail/1.9.9
Cc: Marc Pignat <marc.pignat@hevs.ch>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>
References: <20080403090053.56f243df@tomh> <200804050829.00418.rusty@rustcorp.com.au> <20080405185444.2c433673@tomh>
In-Reply-To: <20080405185444.2c433673@tomh>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804061308.30921.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 April 2008 08:54:44 Tom Horsley wrote:
> On Sat, 5 Apr 2008 08:29:00 +1000
>
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> > I like this idea, and also have module tools ship with
> > a 'check-kernel-cmdline' tool which handles the warnings for unusable
> > cmdline params.  Distributions can run this in their init scripts, and we
> > can remove the warning from the kernel.
>
> Or maybe not have the warning at all, after all, even if
> sillymodule.sillyarg=1 doesn't make sense when I booted, who's to say I
> can't download the source to sillymodule, compile it, and modprobe it after
> boot time :-).

I think it's worse not to have typo protection.  Of course, our logs are so 
noisy they might miss the warning anyway.

Rusty.
