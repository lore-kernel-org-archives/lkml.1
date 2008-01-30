Return-Path: <linux-kernel-owner+w=401wt.eu-S1755072AbYA3FHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbYA3FHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 00:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbYA3FHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 00:07:31 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:58702 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbYA3FHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 00:07:30 -0500
Date: Wed, 30 Jan 2008 05:07:21 +0000
From: Jon Masters <jonathan@jonmasters.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Pavel Roskin <proski@gnu.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>
Subject: Re: ndiswrapper and GPL-only symbols redux
Message-ID: <20080130050721.GB22444@dallas.jonmasters.org>
References: <1201641765.18773.35.camel@dv> <20080129224529.4b8016c3@core> <1201651006.23553.8.camel@dv> <p73bq746lml.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73bq746lml.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.11
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: jcm@dallas.jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 04:24:50AM +0100, Andi Kleen wrote:
> Pavel Roskin <proski@gnu.org> writes:
> >
> > static inline void add_taint_module(struct module *mod, unsigned flag)
> > {
> >         add_taint(flag);
> >         mod->taints |= flag;
> > }
> >
> > The module taint is set before the symbols are resolved.  Therefore, the
> > GPL-only symbols won't be resolved.
> 
> I think using a separate taint flag that does not disable GPL symbols
> for the ndiswrapper case would be a fair solution. After all the main
> motivation for tainting ndiswrapper is to make it visible in oopses, but not 
> prevent it from loading in the first place.
> 
> How about you submit an incremental patch to do that?

I'll happily submit a patch to do whateve is wanted, and add comments
(I'm also debugging seveal module issues right now, so I have a
good opportunity to look over some of the code).

But do we want to:

*). Add a new taint?
*). Move it later?

It's all trivial, but a policy should be established for the future.

Jon.
