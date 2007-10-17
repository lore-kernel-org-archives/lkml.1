Return-Path: <linux-kernel-owner+w=401wt.eu-S934132AbXJQF64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934132AbXJQF64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 01:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756801AbXJQF6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 01:58:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48857 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbXJQF6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 01:58:46 -0400
Date: Tue, 16 Oct 2007 22:38:26 -0700
From: Greg KH <greg@kroah.com>
To: Arjan van de Ven <arjan@infradead.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /proc Security Hooks
Message-ID: <20071017053826.GB28854@kroah.com>
References: <20071016193850.GA5418@roonstrasse.net> <20071016125403.40ec5c18@laptopd505.fenrus.org> <20071017051357.GA4515@roonstrasse.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017051357.GA4515@roonstrasse.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 07:13:57AM +0200, Max Kellermann wrote:
> On 2007/10/16 21:54, Arjan van de Ven <arjan@infradead.org> wrote:
> > On Tue, 16 Oct 2007 21:38:50 +0200
> > Max Kellermann <mk@cm4all.com> wrote:
> > > This patch attempts to unify duplicated code found in modules like
> > > Linux VServer.
> > 
> > can you please merge this patch only when you also merge the first
> > user
> > of it? That's the only way we can keep the LSM hooks sane... is to
> > see
> > them in thew conect of a user.
> 
> I wrote a module which uses this, but it's non-free and only used on
> my employer's servers.

How can a non-GPL module call the security_register() function?

Anyway, we don't/can't add hooks to the kernel for non-GPL code, that's
not allowed.

thanks,

greg k-h
