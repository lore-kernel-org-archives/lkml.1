Return-Path: <linux-kernel-owner+w=401wt.eu-S1764117AbYBANcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764117AbYBANcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 08:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755371AbYBANcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 08:32:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52575 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185AbYBANcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 08:32:42 -0500
Date: Fri, 1 Feb 2008 14:32:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Holger Wolf <wolf@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] latencytop: Change Kconfig dependency.
Message-ID: <20080201133228.GC11070@elte.hu>
References: <20080201130636.GA29660@osiris.boeblingen.de.ibm.com> <20080201132854.GB13251@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201132854.GB13251@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> >  config STACKTRACE_SUPPORT
> >  	def_bool y
> >  
> > +config HAVE_LATENCYTOP_SUPPORT
> > +	def_bool y
> > +
> No.
> Please do:
>  config X86
> +	select HAVE_LATENCYTOP_SUPPORT
> 
> Yes - this is a valid use of select.

i see - and there's lots of other examples of this and other similar 
things in other architectures as well. Could we do that as a separate 
cleanup patch instead, to keep the Kconfig file consistently structured.

	Ingo
