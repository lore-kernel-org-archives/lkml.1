Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbYH0ANg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbYH0ANg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 20:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbYH0AN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 20:13:28 -0400
Received: from mout0.freenet.de ([195.4.92.90]:59461 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbYH0AN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 20:13:27 -0400
Date: Wed, 27 Aug 2008 02:13:23 +0200
From: Gerhard Brauer <gerhard.brauer@web.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080827001323.GF5300@tux1.brauer.lan>
References: <20080826141851.GA5300@tux1.brauer.lan> <20080826145338.GA8601@Krystal> <20080826131354.356ae11d@doriath.conectiva> <20080826171822.GB14906@Krystal> <20080826150222.0cf1542c@doriath.conectiva> <20080826181558.GA16887@Krystal> <20080826203449.GD5300@tux1.brauer.lan> <20080826204814.GB23544@Krystal> <20080826212549.GE5300@tux1.brauer.lan> <20080826213559.GA27498@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080826213559.GA27498@Krystal>
User-Agent: Mutt/1.5.18-muttng (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 05:35:59PM -0400, Mathieu Desnoyers wrote:
> * Gerhard Brauer (gerhard.brauer@web.de) wrote:
> 
> First patch to test :
> 
> x86 alternative text_poke move sync_core

With this got the oops again when compiling in guest. Reboot afterwards
leads to the early oops.

> Second patch to apply on top of the first one :
>  
> x86 alternative text_poke add wbinvd

With second patch i get the early oops after "freeing smp". Seems no way
to get the guest bootet normaly (ony with replace-paravirt).

So the changes from the other mail took more effect IMHO.
I could test more tomorrow if you have more ideas.

> Mathieu

Gerhard

