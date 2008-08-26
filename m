Return-Path: <linux-kernel-owner+w=401wt.eu-S1758257AbYHZVj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbYHZVj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 17:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbYHZVjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 17:39:19 -0400
Received: from mout3.freenet.de ([195.4.92.93]:57847 "EHLO mout3.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbYHZVjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 17:39:18 -0400
X-Greylist: delayed 805 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Aug 2008 17:39:18 EDT
Date: Tue, 26 Aug 2008 23:25:50 +0200
From: Gerhard Brauer <gerhard.brauer@web.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080826212549.GE5300@tux1.brauer.lan>
References: <20080822175741.6bc83dc8@doriath.conectiva> <48AF2ABD.9070100@zytor.com> <20080826141851.GA5300@tux1.brauer.lan> <20080826145338.GA8601@Krystal> <20080826131354.356ae11d@doriath.conectiva> <20080826171822.GB14906@Krystal> <20080826150222.0cf1542c@doriath.conectiva> <20080826181558.GA16887@Krystal> <20080826203449.GD5300@tux1.brauer.lan> <20080826204814.GB23544@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080826204814.GB23544@Krystal>
User-Agent: Mutt/1.5.18-muttng (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 04:48:14PM -0400, Mathieu Desnoyers wrote:
> 
> OK, so we have a problem with interrupts coming while we are doing the
> alternatives patching.
> 
> First thing, I wonder if Virtualbox expects the OS to patch all its
> paravirt instructions in one go ?
> 
> Also, could you then try to :
> - to revert all those changes
> - Do this to text_poke_early and text_poke :
> 
> - put the sync_core() within the irq off critical section
> (test)

Could you please explain more what to change? I don't see where to put
sync_core(), i not found this section in both functions. (I'm not a developer)

> - add a wbinvd();  just after the sync_core() in both functions
> (test).

Also verbose please...

> Thanks,
> 
> Mathieu

Thank you
	Gerhard

