Return-Path: <linux-kernel-owner+w=401wt.eu-S1759180AbZE1SMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759180AbZE1SMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 14:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbZE1SLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 14:11:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53216 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbZE1SLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 14:11:53 -0400
Date: Thu, 28 May 2009 13:17:15 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/38] C/R: core stuff
Message-ID: <20090528181715.GA2384@hallyn.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com> <1242968132-1044-18-git-send-email-adobriyan@gmail.com> <20090526131644.GA20920@hallyn.com> <20090526193503.GB11909@x200.localdomain> <20090526234436.GB23806@hallyn.com> <20090528153852.GC18256@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528153852.GC18256@x200.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> On Tue, May 26, 2009 at 06:44:36PM -0500, Serge E. Hallyn wrote:
> > Quoting Alexey Dobriyan (adobriyan@gmail.com):
> > > And since you guys showed that just idea of in-kernel checkpointing is not
> > > rejected outright, it doesn't mean that you can drag every single idea too.
> > 
> > Can you rephrase here?  I have no idea what you mean by 'drag every single
> > idea'
> 
>   									complexity
>  +-|------------------------------------------------|----------------------|-->
> hypervisor C/R					in-kernel C/R	C/R for unpriviledged
> 								C/R with "leaks"
> 
> I personally thought in-kernel C/R will be rejected outright, but it wasn't.
> This in theory doesn't mean other two issues should be accepted.

Note again that leaving c/R unprivileged was suggested (By Arnd)
as a way to keep us on our toes.  When it actually goes upstream
I would prefer it be under a new CAP_CHECKPOINT_RESTART capability,
not CAP_SYS_ADMIN.

-serge
