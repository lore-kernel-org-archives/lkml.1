Return-Path: <linux-kernel-owner+w=401wt.eu-S1752900AbXDCPyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbXDCPyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 11:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbXDCPyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 11:54:22 -0400
Received: from smtp102.sbc.mail.re2.yahoo.com ([68.142.229.103]:32880 "HELO
	smtp102.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752316AbXDCPyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 11:54:22 -0400
X-YMail-OSG: ycB4KzIVM1mI7tHYmUlr5MXNFfnN8jLx4W3IHEsxuZbF5mNe_.fNQ4HniG1vF8BglGLreESI0Dmd3jJzDbPbyowck_RhRGQjL7C8Mab6qE_6JtlyVD8-
Date: Tue, 3 Apr 2007 10:54:14 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, vatsa@in.ibm.com,
       akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, winget@google.com,
       rohitseth@google.com, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Message-ID: <20070403155414.GA25602@vino.hallyn.com>
References: <20070212081521.808338000@menage.corp.google.com> <20070212085105.170265000@menage.corp.google.com> <20070331024722.GA808@in.ibm.com> <20070402140938.GF17710@sergelap.austin.ibm.com> <20070402142727.GF2456@in.ibm.com> <m1slbiejt0.fsf@ebiederm.dsl.xmission.com> <20070403153220.GA24946@sergelap.austin.ibm.com> <6599ad830704030845p654cf8dh65ccdc46c92d3688@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830704030845p654cf8dh65ccdc46c92d3688@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Menage (menage@google.com):
> On 4/3/07, Serge E. Hallyn <serue@us.ibm.com> wrote:
> >
> >But frankly I don't know where we stand right now wrt the containers
> >patches.  Do most people want to go with Vatsa's latest version moving
> >containers into nsproxy?  Has any other development been going on?
> >Paul, have you made any updates?
> 
> I've not made major changes since the last patch post, just some small
> optimizations and fixes - I've been too tied up with other stuff.
> 
> Whilst I've got no objection in general to using nsproxy rather than
> the container_group object that I introduced in my latest patches, I

Hmm, my largest objection had been that the nsproxy as a container
structure would end up pointing to nsproxy as a namespace proxy.

But if we do as Eric suggests and have one subsystem per namespace type,
rather than one subsystem for all namespaces, I guess that is no longer
a problem.

That still leaves yours.

> think that Vatsa's approach of losing the general container object is
> flawed, since it loses any kind of per-group generic state (e.g. "this
> container is being deleted") and last time I saw it, I think it would
> tend to lose processes so that they didn't show up in any directory in
> the container fs.
> 
> Paul
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
