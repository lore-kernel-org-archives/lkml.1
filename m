Return-Path: <linux-kernel-owner+w=401wt.eu-S1161023AbXBPOlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161023AbXBPOlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 09:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161034AbXBPOlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 09:41:51 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:44814 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161023AbXBPOlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 09:41:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Cv8EEe1gF/+LenA3h8kbf5ajd1SniK2eqUDTcOFiWmrvqoclBlCpC6Sck75vc+8KtRy0h3V4ddGdXpk5roMiXqCDobWkFbWpM2STEmazNVAtl6lf1cnfacBW9gCWSImRNZj94DtqebLqysRlxXItRjeuZe79EjSLahiEVjpQzEI=
From: Maxim <maximlevitsky@gmail.com>
To: "Thiago Galesi" <thiagogalesi@gmail.com>
Subject: Re: [RFC] New driver information
Date: Fri, 16 Feb 2007 16:41:38 +0200
User-Agent: KMail/1.9.6
Cc: "Heikki Orsila" <shdl@zakalwe.fi>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <20070216135851.GA7939@zakalwe.fi> <82ecf08e0702160608q3fbf1a68t16933b32e5db16ff@mail.gmail.com>
In-Reply-To: <82ecf08e0702160608q3fbf1a68t16933b32e5db16ff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702161641.38117.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 February 2007 16:08:53 Thiago Galesi wrote:
> SInce this information does not, in any way, affect the functioning of
> the driver... It is not "executable code", I don't see the point of
> it.
> 
> For "module_licence" we have the restriction of some functions being
> used only for GPL code, but for this?!? I really don't see it...
> 
> Just think: what would this macro do, "executable-code wise"?
> 
> 
> On 2/16/07, Heikki Orsila <shdl@zakalwe.fi> wrote:
> > I just read
> >
> >         http://kerneltrap.org/node/7729
> >
> > and it occured to me that it would be informative to have a new device
> > driver macro. The motivation for the new macro would be 4 issues:
> >
> >         * Is it possible to get specifications for the device?
> >         * If yes, under what terms? (nda, public)
> >         * Where to get public specs?
> >         * How many closed and open drivers in the Linux source tree?
> >
> > I suggest to add following macro:
> >
> > MODULE_SPECIFICATION(terms, source);
> >
> > where "terms" is one of
> >
> >  * MODULE_SPEC_ANY_PARTY_NDA
> >         - specification available to any party for an NDA
> >  * MODULE_SPEC_ANY_PARTY
> >         - specification available in public, or at least available
> >           without NDA to any party
> >  * MODULE_SPEC_RESTRICTED
> >         - none of the above
> >
> > and "source":
> >
> >  * contact address for nda specs
> >  * any public source for a public specification (http://, email address,
> >    ...)
> >  * empty string otherwise
> >
> > I realise this macro somewhat circumvents the purpose of Documentation/
> > directory but the idea is to have a direct 1:1 mapping between drivers
> > and specification sources so that it would be easy to collect statistics
> > of "open" hardware by using grep et al.
> >
> > What do you think? Useless annotations or useful information?
> >
> > --
> > Heikki Orsila                   Barbie's law:
> > heikki.orsila@iki.fi            "Math is hard, let's go shopping!"
> > http://www.iki.fi/shd
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> 

I think both sides are right.

I think that documentation about drivers and their specs is a good thing ( i personally spent lot if time to locate it and find that it is unavailable in some cases)
But I agree that it has no place in executable code , instead I think such list can be in /Documentation or even in MAINTAINERS

	Regards, 
		Maxim Levitsky 
