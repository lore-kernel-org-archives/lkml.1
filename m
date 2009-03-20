Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbZCTNuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbZCTNuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 09:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbZCTNuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 09:50:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:51051 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbZCTNuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 09:50:03 -0400
Date: Fri, 20 Mar 2009 06:50:58 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: dipankar@in.ibm.com, linux-input@vger.kernel.org,
       dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Question about usage of RCU in the input layer
Message-ID: <20090320065058.65d01771@infradead.org>
In-Reply-To: <20090320044541.GE6807@linux.vnet.ibm.com>
References: <20090318215812.15496a86@infradead.org>
	<20090319085628.GA6167@in.ibm.com>
	<20090319071841.63334eff@infradead.org>
	<20090320020750.GA6807@linux.vnet.ibm.com>
	<20090319202032.4c971d92@infradead.org>
	<20090320044541.GE6807@linux.vnet.ibm.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Mar 2009 21:45:41 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> > single CPU is soooo last decade ;-)
> > But seriously I no longer have systems that aren't dual core or SMT
> > in some form... 
> 
> OK, I will ask the stupid question...
> 
> Why not delay bringing up the non-boot CPUs until later in boot?

that'd be throwing out the baby with the bathwater... I'm trying to use 
the other cpus to do some of the boot work (so that the total goes
faster); not using the other cpus would be counter productive to that.
(As is just sitting in synchronize_rcu() when the other cpu is
working.. hence this discussion ;-)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
