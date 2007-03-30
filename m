Return-Path: <linux-kernel-owner+w=401wt.eu-S932097AbXC3RSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbXC3RSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 13:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932226AbXC3RSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 13:18:41 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:58416 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097AbXC3RSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 13:18:40 -0400
Date: Fri, 30 Mar 2007 13:14:58 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Jan Beulich <jbeulich@novell.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix dependency generation
Message-ID: <20070330171458.GA7573@c2.user-mode-linux.org>
References: <460BA292.76E4.0078.0@novell.com> <20070330150843.GA3520@uranus.ravnborg.org> <460D4C35.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <460D4C35.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 04:43:17PM +0100, Jan Beulich wrote:
> >But that will break UM - no??
> >See following note from fixdep:
> > * Note 2: if somebody writes HELLO_CONFIG_BOOM in a file, it will depend onto
> > * CONFIG_BOOM. This could seem a bug (not too hard to fix), but please do not
> > * fix it! Some UserModeLinux files (look at arch/um/) call CONFIG_BOOM as
> > * UML_CONFIG_BOOM, to avoid conflicts with /usr/include/linux/autoconf.h,
> > * through arch/um/include/uml-config.h; this fixdep "bug" makes sure that
> > * those files will have correct dependencies.
> 
> Hmm, didn't see this note. Then this might warrant special casing UML, but
> penalizing all code due to this seems at least odd to me.

If I understand this, I would think that special-casing UML_CONFIG_*
instead of *_CONFIG_* would be the way to go.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
