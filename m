Return-Path: <linux-kernel-owner+w=401wt.eu-S1758717AbZCZOap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717AbZCZOap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 10:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757307AbZCZOag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 10:30:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:60202 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757937AbZCZOaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:30:35 -0400
Subject: Re: [PATCH -tip] x86: unification of cpu/bugs.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20090326141228.GT7030@erda.amd.com>
References: <1238068930.2507.1.camel@ht.satnam>
	 <20090326131236.GE3226@erda.amd.com> <1238074955.2507.5.camel@ht.satnam>
	 <20090326141228.GT7030@erda.amd.com>
Content-Type: text/plain
Date: Thu, 26 Mar 2009 19:59:54 +0530
Message-Id: <1238077794.2507.7.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-26 at 15:12 +0100, Robert Richter wrote:
> > +/*
> > + * Check various bugs
> > + */
> > +static void __init check_various_bugs(void)
> > +{
> > +	check_config();
> > +	check_fpu();
> > +	check_hlt();
> > +	check_popad();
> > +

This is applicable to 32 bit only. right ?

> > +	init_utsname()->machine[1] =
> > +		'0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);
> 

hmm. this can be common.

> Did you evaluate why these functions are 32 bit only? Same applies to
> 64 bit below. It seems this is not a unification and instead only some
> move-around of code.
> 

Thanks for pointing.

--
JSR


