Return-Path: <linux-kernel-owner+w=401wt.eu-S1758098AbZASTT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098AbZASTT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 14:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbZASTTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 14:19:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44792 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbZASTTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 14:19:48 -0500
Date: Mon, 19 Jan 2009 20:17:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Ian Kent <raven@themaw.net>, Andrew Morton <akpm@linux-foundation.org>,
       hpa@zytor.com, Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] autofs: fix the wrong usage of the deprecated
	task_pgrp_nr()
Message-ID: <20090119191729.GB24852@redhat.com>
References: <20090119070801.GA21686@redhat.com> <1232352677.3136.103.camel@zeus.themaw.net> <20090119083208.GA25297@redhat.com> <1232363717.3136.134.camel@zeus.themaw.net> <20090119124253.GA3268@redhat.com> <1232372016.3136.155.camel@zeus.themaw.net> <20090119143046.GA8284@redhat.com> <20090119174836.GA11295@us.ibm.com> <20090119180534.GA22913@redhat.com> <20090119182447.GA15140@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090119182447.GA15140@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19, Serge E. Hallyn wrote:
>
> Quoting Oleg Nesterov (oleg@redhat.com):
> > On 01/19, Serge E. Hallyn wrote:
> > >
> > > But so there does still need to be a patch modifying parse_options()
> > > to return an error if pgrp= was not specified, right?
> >
> > Why? In that case we should use the caller's pgrp. This is what the
> > current tries to do, why should the patch change this behaviour?
>
> Well, because Ian said that not specifying it is supposed to
> be an error :)  I didn't quite understand why, so am fishing
> for more info...

I think you misunderstood him. Or I am totally confused ;)

In any case. Both autofs and autofs4 use current's pgrp if this
option was not specified, and these patches doesn't change this
behaviour.


Actually, I am very much surprized this one-liner patch has so
many questions. Isn't it "obiously correct" ?

Oleg.

