Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbXKPIUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbXKPIUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 03:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbXKPIUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 03:20:07 -0500
Received: from antispam.upcomillas.es ([130.206.70.245]:53245 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbXKPIUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 03:20:05 -0500
Subject: Re: [BUG] New Kernel Bugs
From: Romano Giannetti <romanol@upcomillas.es>
To: Daniel Barkalow <barkalow@iabervon.org>
Cc: Theodore Tso <tytso@mit.edu>, Benoit Boissinot <bboissin@gmail.com>,
       Mark Lord <liml@rtr.ca>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, protasnb@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0711151034340.12193@iabervon.org>
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org>
	 <20071113.033946.114918709.davem@davemloft.net>
	 <20071113034916.2556edd7.akpm@linux-foundation.org>
	 <20071113.035824.40509981.davem@davemloft.net>
	 <20071113041259.79c9a8c5.akpm@linux-foundation.org>
	 <20071113134029.GA30978@elte.hu> <4739AFE0.20705@rtr.ca>
	 <40f323d00711130752k19cab8eauc3456721274b3267@mail.gmail.com>
	 <20071113171356.GA25824@thunk.org>
	 <Pine.LNX.4.64.0711141810110.12193@iabervon.org>
	 <20071115153057.GE17180@thunk.org>
	 <Pine.LNX.4.64.0711151034340.12193@iabervon.org>
Content-Type: text/plain; charset=ISO-8859-15
Date: Fri, 16 Nov 2007 09:20:02 +0100
Message-Id: <1195201202.13688.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(Cc: trimmed a bit).

On Thu, 2007-11-15 at 11:19 -0500, Daniel Barkalow wrote:
> On Thu, 15 Nov 2007, Theodore Tso wrote:
[...]
> > A full kernel build with everything selected can take good 30 minutes or 
> > more, and that's on a fast dual-core machine with 4gigs of memory and 
> > 7200rpm disk drives. On a slower, memory limited laptop, doing a single 
> > kernel build can take more time than the user has patiences; multiply 
> > that by 7 or 8 build and test boots, and it starts to get tiresome.
> 
> None of this is going to take as long, 

Well, the compile phase can. Especially if the first time you try to
compile the kernel with EXTRAVERSION=`git describe` which force almost a
full rebuild every time...

But the worst problem is that a full recompile, with a distro .config,
will take hours on my 2.66GHz/CoreDuo/1G ram. Trimming down .config is
fundamental to be able to bisect effectively, but it's not an easy thing
to do for an unexperienced user (and a painful one for all the rest of
us). 

What would be an invaluable help would be a tool that generates
a .config with all the modules and subsystems I am using *now*. Should
be possible in principle by parsing KConfig and Makefiles and using as
input the current .config and lsmod... is it possible to map the kernel
object name to the option enabling it?

Romano 


-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
