Return-Path: <linux-kernel-owner+w=401wt.eu-S1762430AbZATBfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762430AbZATBfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 20:35:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932084AbZATBfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 20:35:21 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43362 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761893AbZATBfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 20:35:19 -0500
X-Sasl-enc: draWt7NxM/Lib7MrvXKw4XB97BWAdNGN+bh0k4kHuIes 1232415317
Subject: Re: [PATCH] autofs: fix the wrong usage of the deprecated
	task_pgrp_nr()
From: Ian Kent <raven@themaw.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090119191729.GB24852@redhat.com>
References: <20090119070801.GA21686@redhat.com>
	 <1232352677.3136.103.camel@zeus.themaw.net>
	 <20090119083208.GA25297@redhat.com>
	 <1232363717.3136.134.camel@zeus.themaw.net>
	 <20090119124253.GA3268@redhat.com>
	 <1232372016.3136.155.camel@zeus.themaw.net>
	 <20090119143046.GA8284@redhat.com> <20090119174836.GA11295@us.ibm.com>
	 <20090119180534.GA22913@redhat.com> <20090119182447.GA15140@us.ibm.com>
	 <20090119191729.GB24852@redhat.com>
Content-Type: text/plain
Date: Tue, 20 Jan 2009 10:35:19 +0900
Message-Id: <1232415319.3136.18.camel@zeus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-19 at 20:17 +0100, Oleg Nesterov wrote:
> On 01/19, Serge E. Hallyn wrote:
> >
> > Quoting Oleg Nesterov (oleg@redhat.com):
> > > On 01/19, Serge E. Hallyn wrote:
> > > >
> > > > But so there does still need to be a patch modifying parse_options()
> > > > to return an error if pgrp= was not specified, right?
> > >
> > > Why? In that case we should use the caller's pgrp. This is what the
> > > current tries to do, why should the patch change this behaviour?
> >
> > Well, because Ian said that not specifying it is supposed to
> > be an error :)  I didn't quite understand why, so am fishing
> > for more info...
> 
> I think you misunderstood him. Or I am totally confused ;)
> 
> In any case. Both autofs and autofs4 use current's pgrp if this
> option was not specified, and these patches doesn't change this
> behaviour.
> 
> 
> Actually, I am very much surprized this one-liner patch has so
> many questions. Isn't it "obiously correct" ?

Maybe it is.

Sorry Serge, this was actually the first of two patches from Oleg and I
only copied you on the first (since that is where I started the
discussion), oops!

The reason this has become so difficult is largely my fault and it is
entirely due to my lack of understanding of how automount will play
within pid namespaces.

But your last reply to me was very helpful in this regard, thanks for
your patience. So this painful discussion has been useful, at least to
me.

I see you've already backed out part of your original change, which may
have been a little premature, as I can likely go back and review the
original patches now.

Ian


