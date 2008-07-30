Return-Path: <linux-kernel-owner+w=401wt.eu-S1760585AbYG3LV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760585AbYG3LV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 07:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbYG3LVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 07:21:16 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:51907 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601AbYG3LVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 07:21:16 -0400
Date: Wed, 30 Jul 2008 13:21:36 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: petkovbb@gmail.com
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/5] docsrc: build Documentation/ sources
Message-ID: <20080730112136.GA19465@uranus.ravnborg.org>
References: <12173619152424@xenotime.net> <20080729202732.GB6007@gollum.tnic> <20080730084405.GD18366@uranus.ravnborg.org> <9ea470500807300155t60732956m67d196f87aed9fa4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ea470500807300155t60732956m67d196f87aed9fa4@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > With the current approach we have much better build coverage.
> > All "allyesconfig" and "allmodconfig" builds will do the test
> > builds which is a good think.
> > If we introduce "make docsrc" then almost only Randy will do the
> > test builds and report the breakage - which is not good.
> 
> Well, i don't see anymore people than Randy doing
> 
> CONFIG_BUILD_DOCSRC=1 make ...

One such example is:
http://kisskb.ellerman.id.au/linux-next

Here the all*config will do the build test of the
documentation and Stephen will tell if it breaks.

> either so only the other option remains, which means CONFIG_BUILD_DOCSRC
> should be "default y" for more coverage...
No - we do not want to set config options to "default y" unless
there are _very_ good reasons to do so.

You should check a few of Linus' responses during
this merge window if you want more background on this.
	Sam
