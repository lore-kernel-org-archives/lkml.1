Return-Path: <linux-kernel-owner+w=401wt.eu-S1752959AbXJQFYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbXJQFYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 01:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbXJQFYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 01:24:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43015 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbXJQFYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 01:24:19 -0400
Date: Tue, 16 Oct 2007 22:21:59 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Max Kellermann <max@duempel.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /proc Security Hooks
Message-ID: <20071016222159.533aea4c@laptopd505.fenrus.org>
In-Reply-To: <20071017051357.GA4515@roonstrasse.net>
References: <20071016193850.GA5418@roonstrasse.net>
	<20071016125403.40ec5c18@laptopd505.fenrus.org>
	<20071017051357.GA4515@roonstrasse.net>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 07:13:57 +0200
Max Kellermann <max@duempel.org> wrote:

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
> my employer's servers.  But I could have a closer look at the Vserver
> code and try to make it use my patch.

doesn't sound like something we'd want overhead for in the generic
kernel....

