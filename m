Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029Ab0ARLXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab0ARLXE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 06:23:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843Ab0ARLXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 06:23:01 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:40284 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab0ARLW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 06:22:59 -0500
Date: Mon, 18 Jan 2010 12:22:56 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Michal Marek <mmarek@suse.cz>
Cc: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>,
       linux-kbuild@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Miller <davem@davemloft.net>, stefanr@s5r6.in-berlin.de,
       adi@hexapodia.org, david.vrabel@csr.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, cocci@diku.dk,
       Andrew Morton <akpm@linux-foundation.org>,
       Nicolas Palix <npalix@diku.dk>
Subject: Re: SmPL scripts into build environment?
In-Reply-To: <4B543EF2.50605@suse.cz>
Message-ID: <Pine.LNX.4.64.1001181220530.14962@ask.diku.dk>
References: <4B502C6B.7000802@s5r6.in-berlin.de> <20100115.005445.263291449.davem@davemloft.net>
 <tkrat.e88dd4dbf17f9bde@s5r6.in-berlin.de> <20100115.012233.202457727.davem@davemloft.net>
 <Pine.LNX.4.64.1001151039080.23543@ask.diku.dk>
 <84144f021001150149u3b784d26g1822be6c5c3ecbf@mail.gmail.com>
 <Pine.LNX.4.64.1001151101320.23543@ask.diku.dk> <20100115110845.GB28625@sirena.org.uk>
 <Pine.LNX.4.64.1001151303580.23543@ask.diku.dk> <20100115133933.GB21188@rakim.wolfsonmicro.main>
 <4B509C90.10305@freemail.hu> <4B543EF2.50605@suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Documentation/smpl/$name_of_problem_fixed.cocci? Or maybe better
> scripts/smlp/..., if you are going to add some wrapper that runs the
> semantic patches on the source tree. Or something like that, a dedicated
> subdirectory to store the semantic patches in individual files.

The idea is to make it possible to run them, assuming the user has 
installed Coccinelle, so scripts seems better.

> > What do you think the best way would be to introduce some check like this
> > in the build environment?
> 
> I've only heard about the tool, I haven't used it yet. Does it need to
> preprocess and parse source files like sparse does, or can it check C
> files without expanding macros and includes?

It doesn't need to preprocess the source files.

thanks,
julia
