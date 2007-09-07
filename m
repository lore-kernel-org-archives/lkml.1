Return-Path: <linux-kernel-owner+w=401wt.eu-S1758262AbXIGRXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262AbXIGRXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 13:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757960AbXIGRXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 13:23:04 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:52905 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757867AbXIGRXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 13:23:04 -0400
Date: Fri, 7 Sep 2007 19:24:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] build system: section garbage collection for vmlinux
Message-ID: <20070907172425.GA12977@uranus.ravnborg.org>
References: <200709051443.21522.vda.linux@googlemail.com> <200709061157.44080.vda.linux@googlemail.com> <1189091630.8490.1.camel@imap.mvista.com> <200709061807.33740.vda.linux@googlemail.com> <1189182671.6303.42.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189182671.6303.42.camel@imap.mvista.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel.

> > I did that before I posted patches to lkml.
> > IOW: posted patches are not broken versus module loading.
> 
> Ok, this is more like the explanation I was looking for..
> 
> During this thread you seemed to indicate the patches you release
> reduced the kernel ~10% , but now your saying that was pre-release ,
> right? 

What are you after here?

If you read the inital post you see the actual savings and you also
can read that it works wiht modules. The precentage can be calculated
from these numbers if you are interested.

As explained later this patch does NOT remove exported symbols
since they may be used by modules that are not included in the actual
build.
And the patch works for x86_64.

So I'm a bit puzzeled what you are trying to bring forward here.
And please read carefully the initial posting again...

	Sam
