Return-Path: <linux-kernel-owner+w=401wt.eu-S1763645AbXKQRz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763645AbXKQRz0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 12:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757606AbXKQRzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 12:55:12 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:23549 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334AbXKQRzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 12:55:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tQn32x8pgTGNzm+T0DV4ii9sfolJ2xiubHjAeCsTAzETKwxAXYVUPsLq3/jPtK4pvotz+ztCv5h2KplOuGBg5AVc5qjhc4qfU1j5QwZrFxetTPzJYrfI8B0rlccnw+urB5z9GFCw6LvZEI4QbX/81yma7KbiyD4zArw8/9eMjE8=
Subject: Re: Is it possible to give the user the option to cancel forkbombs?
From: Dane Mutters <dmutters@gmail.com>
To: Diego Calleja <diegocg@gmail.com>
Cc: Martin Olsson <mnemo@minimum.se>, Peter Zijlstra <peterz@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <20071117165325.3e5f571a.diegocg@gmail.com>
References: <473E815F.30900@minimum.se>
	 <20071116213137.6efe3f9e@the-village.bc.nu> <473E9290.3040006@minimum.se>
	 <1195281942.15929.5.camel@Orchestrator> <1195285481.3059.12.camel@twins>
	 <473F281B.60408@minimum.se>  <20071117165325.3e5f571a.diegocg@gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Sat, 17 Nov 2007 09:55:01 -0800
Message-Id: <1195322101.15120.3.camel@Orchestrator>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-11-17 at 16:53 +0100, Diego Calleja wrote:
> El Sat, 17 Nov 2007 09:42:51 -0800, Martin Olsson <mnemo@minimum.se> escribió:
> 
> > I don't think that setting a max process count by default is a 
> > good/viable solution. 
> 
> 
> I don't see why...OS X had a default limit of 100 processes per uid (increased
> to 266 in 10.5) and "it works" (many people notices it, but it's not surprising
> since the limit is too restrictive).
> 
> If you don't have limits, you can't avoid starvation easily. From my experience,
> since I use CFS, fork/compile bombs (forgetting to put a number after make -j...)
> are very sluggish mainly because the whole graphic subsystem is paged out.

I don't know if this is at all feasible, but is it possible to have a
mechanism that would detect a fork bomb in progress and either stop the
fork, or allow the user to cancel the operation?  For example, are there
any legitimate processes (i.e. ones that really need to fork like crazy)
that would need to generate 200+ processes in less than 1 second?

(Note: I'm not a programmer; I'm just throwing out the idea.)

-Dane

