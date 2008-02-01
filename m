Return-Path: <linux-kernel-owner+w=401wt.eu-S1759422AbYBAQvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422AbYBAQvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 11:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbYBAQvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 11:51:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60821 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703AbYBAQvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 11:51:37 -0500
Date: Fri, 1 Feb 2008 17:51:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       linux-kernel@vger.kernel.org,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: Avoid section mismatch involving arch_register_cpu
Message-ID: <20080201165123.GA30822@elte.hu>
References: <20080201145649.GA12318@mailshack.com> <20080201164422.GA14633@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201164422.GA14633@uranus.ravnborg.org>
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

> > The only external user of arch_register_cpu in the tree is in 
> > drivers/acpi/processor_core.c where it is guarded by 
> > ACPI_HOTPLUG_CPU (which depends on HOTPLUG_CPU).
> > 
> > Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> > CC: Sam Ravnborg <sam@ravnborg.org>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>
> 
> Added Ingo so he can pick it up.

yep, already did so.

	Ingo
