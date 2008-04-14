Return-Path: <linux-kernel-owner+w=401wt.eu-S1762237AbYDNVSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762237AbYDNVSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 17:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbYDNVSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 17:18:05 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59345 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbYDNVSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 17:18:02 -0400
Date: Mon, 14 Apr 2008 16:18:01 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, manfred@colorfullife.com,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com, xemul@openvz.org,
       sukadev@us.ibm.com
Subject: Re: [PATCH 1/2] fix sys_unshare()+SEM_UNDO: add support for
	CLONE_SYSVSEM
Message-ID: <20080414211801.GA676@sergelap.austin.ibm.com>
References: <200804130848.m3D8mU7D007104@mail.q-ag.de> <20080413015936.580bf7fe.akpm@linux-foundation.org> <4801F038.8020003@colorfullife.com> <20080414145840.GA15667@sergelap.austin.ibm.com> <20080414123917.b750886a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414123917.b750886a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Mon, 14 Apr 2008 09:58:40 -0500
> "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> 
> > Quoting Manfred Spraul (manfred@colorfullife.com):
> > > Andrew Morton wrote:
> > >> On Sun, 13 Apr 2008 10:04:17 +0200 Manfred Spraul 
> > >> <manfred@colorfullife.com> wrote:
> > >>
> > >>> sem_undo_list **new_ulistp)
> > >>>  {
> > >>> -	if (unshare_flags & CLONE_SYSVSEM)
> > >>> -		return -EINVAL;
> > >>> +	if (unshare_flags & CLONE_SYSVSEM) {
> > >>> +		*new_ulistp = (void*)1;
> > >>> +	}
> > >>>     
> > >>
> > >> And can we do anything nicer than this?
> > >>
> > >>   
> > > Attached is an alternative. If you prefer it, I'll send another patch set.
> > 
> > FWIW I definately far far prefer this version  :)
> 
> Oh, OK.
> 
> I guess I'll drop what I have.  Manfred, can we please have a new patchset?
> 
> We might end up slipping this back to 2.6.25.1.  Would that be a bad thing?

It'd be unfortunate, but as the existing patch doesn't completely fix
the problem it's probably best to wait anyway.

Manfred, I don't want to step on your toes, but please do let me know if
you don't have time to do the next version.  If you do have time, then
thank you again for spotting+fixing the problem.

thanks,
-serge
