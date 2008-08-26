Return-Path: <linux-kernel-owner+w=401wt.eu-S1756866AbYHZVwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbYHZVwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 17:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbYHZVvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 17:51:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58992 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbYHZVvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 17:51:53 -0400
Message-ID: <48B47AD2.5080609@zytor.com>
Date: Tue, 26 Aug 2008 14:51:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Gerhard Brauer <gerhard.brauer@web.de>,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
References: <48AF2ABD.9070100@zytor.com> <20080826141851.GA5300@tux1.brauer.lan> <20080826145338.GA8601@Krystal> <20080826131354.356ae11d@doriath.conectiva> <20080826171822.GB14906@Krystal> <20080826150222.0cf1542c@doriath.conectiva> <20080826181558.GA16887@Krystal> <20080826203449.GD5300@tux1.brauer.lan> <20080826204814.GB23544@Krystal> <20080826212549.GE5300@tux1.brauer.lan> <20080826213559.GA27498@Krystal>
In-Reply-To: <20080826213559.GA27498@Krystal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> x86 alternative text_poke add wbinvd
> 
> Add a cache flush instruction before reenabling interrupts in text_poke.
> 
> If this works, we could use clflush() (which is sadly buggy on some archs) which
> is faster since it only clear a cacheline instead of the entire cache.
> 

Well, in this case it's VirtualBox we're talking about, a virtual 
architecture.  It's hard to know what it will do under *any* circumstances.

	-hpa
