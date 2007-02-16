Return-Path: <linux-kernel-owner+w=401wt.eu-S1423360AbXBPGpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423360AbXBPGpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 01:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423359AbXBPGpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 01:45:21 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:5687 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423351AbXBPGpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 01:45:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dmA0/OfLuphyN5lOYQvThci917QvPESMO36hRUK7/Ic9tLGUJWOC4r795b6NB3ZJ++Q6EF63jngd6gvRgAAYTReCtOjA68gnTPctsg62wib3IPO8AJveSgQGKLd+BzR/ImpjEpfXFo/OnfncOTYIDmpNQ19TY83Dj2GtskYQelY=
Message-ID: <3d57814d0702152245q19e19141me0b999fb051ac7b6@mail.gmail.com>
Date: Fri, 16 Feb 2007 16:45:15 +1000
From: "Trent Waddington" <trent.waddington@gmail.com>
To: "v j" <vj.linux@gmail.com>
Subject: Re: GPL vs non-GPL device drivers
Cc: "David Lang" <david.lang@digitalinsight.com>,
       "Scott Preece" <sepreece@gmail.com>,
       "Miguel Ojeda" <maxextreme@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <9b3a62ab0702152225m3893318by95cb8b260c74bfc2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
	 <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com>
	 <20070215165339.GB5285@thunk.org>
	 <9b3a62ab0702151020k5bd0e4c9w763e1b01288ccc4f@mail.gmail.com>
	 <653402b90702151102n3a3e0435r837e2191de79b2b@mail.gmail.com>
	 <7b69d1470702151712x685f3e0eqf6198f9bb7f2394e@mail.gmail.com>
	 <Pine.LNX.4.63.0702151701510.10070@qynat.qvtvafvgr.pbz>
	 <9b3a62ab0702152148p57db8b1dgd42b1c6fb15dccbb@mail.gmail.com>
	 <3d57814d0702152157n461a9f0cta0a0c20e9a592d83@mail.gmail.com>
	 <9b3a62ab0702152225m3893318by95cb8b260c74bfc2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/16/07, v j <vj.linux@gmail.com> wrote:
> > It's written in black and white, in the license.
>
> Please point me to where it says I cannot load proprietary modules in
> the Kernel.

It doesn't.  It does, however, say you can't distribute your module
unless you make it available under the same terms as the kernel.  It
makes that really clear.

I'll say that again, for everyone else who is reading this: the GPL
makes it really clear that extensions to a GPL work are required to be
distributed under the terms of the GPL.  All this junk about
"derivative works" is just the legal jargon used to implement the
intent of the GPL.  You can argue that a particular extension isn't a
derivative work if you want, but you can't argue with the intent..
cause it is written in plain english.

> I know his opinion. I don't debate his opinion. It is his code. I
> choose not to use his code because of the license issue.

That's good.

> No, just that the trend is disturbing. If enough Kernel Developers
> choose to write their Software in a way that prevents others from
> using it freely, then that is troubling. Especially when these Kernel
> Developers are substituting existing interfaces in the Kernel with
> ones that are NEW and require specific licenses.

It's hardly a new trend.. the kernel has always been GPL.. the intent
has always been that all extensions that are distributed be
distributed under the GPL.  This whole EXPORT_SYMBOL_GPL thing is
new.. but it doesn't require your module to be under the GPL to load,
it requires that your module export a license declaration that claims
it is GPL - you can do that without changing your license.  Frankly, I
don't understand why you're willing to ignore the intent of the GPL
but you don't appear to be willing to just make your module export a
license declaration of "GPL".

Trent
