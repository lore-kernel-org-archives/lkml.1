Return-Path: <linux-kernel-owner+w=401wt.eu-S1764418AbXEYSdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764418AbXEYSdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 14:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763628AbXEYSdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 14:33:11 -0400
Received: from [81.2.110.250] ([81.2.110.250]:46046 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752060AbXEYSdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 14:33:10 -0400
Date: Fri, 25 May 2007 19:37:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <ak@suse.de>
Cc: Dave Jones <davej@redhat.com>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Multiple free during oprofile unload
Message-ID: <20070525193737.34609de2@the-village.bc.nu>
In-Reply-To: <200705252002.58967.ak@suse.de>
References: <4656FA04.5000403@redhat.com>
	<200705251913.53097.ak@suse.de>
	<20070525173813.GA2875@redhat.com>
	<200705252002.58967.ak@suse.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007 20:02:58 +0200
Andi Kleen <ak@suse.de> wrote:

> 
> > If the functionality is completely busted in -stable,
> 
> It's not; e.g. it works great on my P4 testbox with 2.6.21
> 
> > adding a patch that's 
> > isolated to that component can't really make things much worse.
> > All we've done here is move the breakage.
> 
> I don't think stable is the right place for development.

I'd agree entirely with Dave - if you are applying a fix to something
that is currently totally broken which may make it work and which doesn't
affect any other bit of code then it goes into the stable tree.

Absolutes like "no xyz in the stable tree" don't work in the real world
with real users. Intelligence does.
