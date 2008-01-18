Return-Path: <linux-kernel-owner+w=401wt.eu-S1759419AbYARFL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419AbYARFL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 00:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756203AbYARFLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 00:11:14 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:59051 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759047AbYARFLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 00:11:13 -0500
Date: Fri, 18 Jan 2008 06:11:18 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: travis@sgi.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu, Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/6] percpu: Change Kconfig ARCH_SETS_UP_PER_CPU_AREA to HAVE_SETUP_PER_CPU_AREA
Message-ID: <20080118051118.GA14882@uranus.ravnborg.org>
References: <20080117223505.203884000@sgi.com> <20080117223505.513183000@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117223505.513183000@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike.

> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -20,6 +20,7 @@ config X86
>  	def_bool y
>  	select HAVE_OPROFILE
>  	select HAVE_KPROBES
> +	select HAVE_SETUP_PER_CPU_AREA if ARCH = "x86_64"

It is simpler to just say:
> +	select HAVE_SETUP_PER_CPU_AREA if X86_64

And this is the way we do it in the rest of the
x86 Kconfig files.

	Sam
