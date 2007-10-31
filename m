Return-Path: <linux-kernel-owner+w=401wt.eu-S1759411AbXJaAxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411AbXJaAxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 20:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbXJaAxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 20:53:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45125 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751351AbXJaAxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 20:53:14 -0400
Date: Tue, 30 Oct 2007 17:51:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 3/4] Add ARCH_SUPPORTS_KPROBES
In-Reply-To: <20071031003330.255163971@polymtl.ca>
Message-ID: <alpine.LFD.0.999.0710301748030.30120@woody.linux-foundation.org>
References: <20071031003140.904670073@polymtl.ca>
 <20071031003330.255163971@polymtl.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Oct 2007, Mathieu Desnoyers wrote:
>  
> +config ARCH_SUPPORTS_KPROBES
> +	bool
> +	default y

Actually, I know I gave this as the magic incantation, but now that I see 
it, I realize that I should have told you to just use

	config ARCH_SUPPORTS_KPROBES
		def_bool y

instead, which is a bit denser. 

We seem to use both kinds of syntax for these things, but this is really 
what "def_bool" is there for...

		Linus
