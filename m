Return-Path: <linux-kernel-owner+w=401wt.eu-S936907AbXGZUSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936907AbXGZUSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 16:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932115AbXGZUSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 16:18:43 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58294 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356AbXGZUSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 16:18:42 -0400
Subject: Re: 2.6.23-rc1-mm1
From: Dave Hansen <haveblue@us.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: Gabriel C <nix.or.die@googlemail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
In-Reply-To: <20070726000705.GB21056@suse.de>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
	 <6bffcb0e0707251148m219d1c9fqb557d3e5364f679b@mail.gmail.com>
	 <20070725185328.GA28199@uranus.ravnborg.org> <46A7A1EF.8060307@zytor.com>
	 <46A7B983.90407@googlemail.com> <46A7BB12.7060504@googlemail.com>
	 <20070726000705.GB21056@suse.de>
Content-Type: text/plain
Date: Thu, 26 Jul 2007 13:18:36 -0700
Message-Id: <1185481116.18414.124.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-25 at 17:07 -0700, Greg KH wrote:
> 
> > > WARNING: Absolute relocations present
> > > Offset     Info     Type     Sym.Value Sym.Name
> > > c0202e73 00703601   R_386_32 c03071bc  _sdata
> > > 
> > > $ grep c03071bc System.map
> > > c03071bc R __tracedata_end
> > > c03071bc A _sdata
> > 
> > 
> > Guessing is this patch ?
> > 
> >
> gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch:
> __tracedata_end = .;
> >
> gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch:+
> _sdata = .;                     /* End of text section */
> 
> This patch is a horrible hack to try to see if kobjects are static and
> not dynamically created.
> 
> Dave, any ideas what is happening here? 

I've seen those warnings for other random stuff, but I have no idea what
they mean. :(

Is there a preferred way to access symbol addresses?

-- Dave

