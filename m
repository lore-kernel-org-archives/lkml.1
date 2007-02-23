Return-Path: <linux-kernel-owner+w=401wt.eu-S932067AbXBWKJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbXBWKJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 05:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932091AbXBWKJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 05:09:23 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60076 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932067AbXBWKJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 05:09:22 -0500
Date: Fri, 23 Feb 2007 02:09:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: pgf111000 <junkmail@petergfrazier.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Areca driver 2.6.19 on x86_64
Message-Id: <20070223020914.4a9a7ece.akpm@linux-foundation.org>
In-Reply-To: <9113207.post@talk.nabble.com>
References: <3193.213.203.144.13.1165423892.squirrel@mailserver.omnibit.it>
	<20061206230949.GA25461@brong.net>
	<000301c719a9$70e4f8d0$2900a8c0@arecakevin>
	<9113207.post@talk.nabble.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 22 Feb 2007 20:04:07 -0800 (PST) pgf111000 <junkmail@petergfrazier.com> wrote:
> 
> These solutions are laughable....
> 
> 
> 
> 
> Areca Support wrote:
> > 
> > Dear Sir,
> > 
> > This is Kevin Wang from Areca Technology, Tech-Support Team.
> > regarding your problem, please trying to disable ACPI in kernel loader.
> > if the problem happen as soon as driver loaded, it should be the IRQ
> > releated issue.
> > the motherboard bios didn't assigned a correct IRQ to controller, it makes
> > the driver can't initialize controller.
> > and in our experience, disable ACPI in kernel loader can solved this ussue
> > in some distro.

What we're probably looking at here are BIOS bugs.

But areca's suggestions are good ones: if those things fix the problem then
we probably need to fix Linus acpi or, more likely, add suitable
workarounds for yet more BIOS bugs.

So yes, please try the diagnostic steps which they suggested and if that
helps, raise a report against acpi at bugzilla.kernel.org.

