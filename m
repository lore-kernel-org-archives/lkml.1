Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbYIDILW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbYIDILW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbYIDILH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:11:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:36826 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbYIDILE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:11:04 -0400
Subject: Re: [PATCH 2/2] powerpc - Make the irq reverse mapping radix tree
	lockless
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: dwalker@mvista.com, tinytim@us.ibm.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       jean-pierre.dion@bull.net, michael@ellerman.id.au,
       linuxppc-dev@ozlabs.org, paulus@samba.org, gilles.carry@ext.bull.net,
       tglx@linutronix.de
In-Reply-To: <20080904095507.207d1091@bull.net>
References: <1218029429-21114-1-git-send-email-sebastien.dugue@bull.net>
	 <1218029429-21114-3-git-send-email-sebastien.dugue@bull.net>
	 <1219209781.21386.25.camel@pasglop> <20080903154105.7dff49db@bull.net>
	 <1220496739.4879.20.camel@pasglop> <20080904092252.12b3df4a@bull.net>
	 <1220513643.4879.68.camel@pasglop>  <20080904095507.207d1091@bull.net>
Content-Type: text/plain
Date: Thu, 04 Sep 2008 17:58:56 +1000
Message-Id: <1220515136.4879.70.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>   There's nothing to 'de-initialize' here, or am I missing something?
> radix_tree_insert() will return ENOMEM and won't insert anything.

Forget my comment, just fallback.

> > Or you can fallback if you don't find, as easy, probably
> > easier since it shouldn't happen in practice.
> 
>   That's what I had in mind.

Thanks for doing that work !

Cheers,
Ben.


