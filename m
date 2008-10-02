Return-Path: <linux-kernel-owner+w=401wt.eu-S1754440AbYJBR7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbYJBR7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 13:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbYJBR7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 13:59:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50999 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbYJBR7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 13:59:46 -0400
Date: Thu, 2 Oct 2008 13:59:40 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 5/5] xen: nuke the ballon files
In-Reply-To: <48E4EA1C.2090808@goop.org>
Message-ID: <alpine.DEB.1.10.0810021357360.2919@gandalf.stny.rr.com>
References: <20081002150529.087488257@goodmis.org> <20081002151105.025170721@goodmis.org> <48E4EA1C.2090808@goop.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2 Oct 2008, Jeremy Fitzhardinge wrote:

> Steven Rostedt wrote:
> > Investigating the unused static files in the balloon code, I discovered
> > that the balloon code is not used at all.
> > 
> > The header file is one big #if 0 and all the functions in the C file
> > is static. There is no caller like init_module to hook to any of
> > these functions. Basically, this code is one big patch of dead code
> > wasting space on my hard drive.
> > 
> > This patch removes the balloon code altogether since there are no
> > users.
> >   
> 
> Er, I think you should back away from that crack pipe.

No, coffee is my drug of choice. I did have a bit of overdose today ;-)

> 
> > -subsys_initcall(balloon_init);

Ouch! How did I miss that.

Anyway, there are still a bunch of functions in that code that are not 
referenced.  OK, nack this patch, but could you please supply one that 
cleans that code up.

Thanks,

-- Steve

