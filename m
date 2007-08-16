Return-Path: <linux-kernel-owner+w=401wt.eu-S1752731AbXHPVHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbXHPVHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 17:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757796AbXHPVHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 17:07:07 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:52474 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757762AbXHPVHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 17:07:05 -0400
Date: Thu, 16 Aug 2007 17:05:08 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@osdl.org>,
       stable@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Alberto Pires de Oliveira Neto <apon1@terra.com.br>, giedrius@su.lt
Subject: Re: [PATCH] UML - Add a .note.SuSE section
Message-ID: <20070816210508.GA10559@c2.user-mode-linux.org>
References: <20070816162428.GA8128@c2.user-mode-linux.org> <1187281856.2663.0.camel@laptopd505.fenrus.org> <20070816192639.GA8957@c2.user-mode-linux.org> <20070816200455.GA14424@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070816200455.GA14424@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 10:04:55PM +0200, Sam Ravnborg wrote:
> On Thu, Aug 16, 2007 at 03:26:39PM -0400, Jeff Dike wrote:
> > 
> > The crash is in this section:
> > 
> >   __uml_setup_start = .;
> >   .uml.setup.init : { *(.uml.setup.init) }
> >   __uml_setup_end = .;
> 
> This looks like a classic bug.
> You wanted this:
> .uml.setup.init : {
> 	__uml_setup_start = .;
> 	*(.uml.setup.init)
> 	__uml_setup_end = .;
> }

Ooh, this sounds promising, thanks.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
