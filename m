Return-Path: <linux-kernel-owner+w=401wt.eu-S1753612AbYL3ARx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbYL3ARx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 19:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbYL3ARo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 19:17:44 -0500
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:56195 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbYL3ARn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 19:17:43 -0500
Date: Mon, 29 Dec 2008 18:17:29 -0600
From: Nathan Lynch <ntl@pobox.com>
To: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Gilles Carry <Gilles.Carry@ext.bull.net>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [RFC][PATCH] Fix cpu hotplug hang
Message-ID: <20081230001729.GD6958@localdomain>
References: <20081201140907.56743abd@bull.net>
 <20081215123128.172b21be@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081215123128.172b21be@bull.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Pobox-Relay-ID: 4434D77A-D607-11DD-AC43-5720C92D7133-04752483!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastien Dugue wrote:
> On Mon, 1 Dec 2008 14:09:07 +0100 Sebastien Dugue <sebastien.dugue@bull.net> wrote:
> 
> > 
> >   here is a patch that fixes a CPU hotplug hang I get on a Power6
> > box. It may not be the only possible fix but it appears to be the
> > cleanest I can think of at the moment.
> > 
> >   Comments welcomed.
> 
>   Ingo, Thomas, anybody care to comment on the hang and this possible fix?

FWIW, I was able to recreate this hang with 2.6.28 on a 8-way Power5
system, and Sebastien's patch does appear to fix the problem for my
testcase, which does a few hundred offline/online operations.
