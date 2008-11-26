Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbYKZRIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbYKZRIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 12:08:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYKZRHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 12:07:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43940 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbYKZRHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 12:07:52 -0500
Date: Wed, 26 Nov 2008 11:08:51 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: mtk.manpages@gmail.com
Cc: Pavel Emelyanov <xemul@openvz.org>, Kir Kolyshkin <kir@openvz.org>,
       linux-man@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: Re: Documentation for CLONE_NEWPID
Message-ID: <20081126170851.GA24943@hallyn.com>
References: <4923810B.7010201@gmail.com> <20081123222023.GB12687@hallyn.com> <cfd18e0f0811250709x4e2cc5cdhafb9ccf494890442@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0811250709x4e2cc5cdhafb9ccf494890442@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Michael Kerrisk (mtk.manpages@googlemail.com):
> Hi Serge,
> > I assume you've considered the pros and cons of mentioning
> > signal semantics with respect to init tasks of child pid namespaces,
> > and decided it's not worth mentioning yet as the semantics are not
> > yet finalized?
> >
> > The goal is to treat the process as a system-wide init with respect
> > to signals coming from its own namespace, and treat it as an ordinary
> > task for signals coming from its ancestor namespaces.  But as you've
> > probably read, the implementation may result in some unfortunate
> > side-effects regarding blocked signals etc.
> 
> No I haven't considered this at all.  Could you provide some pointers
> to relevant discussions on this?

The discussions are going on right now on lkml (see for instance
http://lkml.org/lkml/2008/11/15/124).  But I think Nadia has already
written something up.  Nadia, could you send what you have to
Michael?

thanks,
-serge
