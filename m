Return-Path: <linux-kernel-owner+w=401wt.eu-S1751918AbXE3Gik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbXE3Gik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 02:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbXE3Gic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 02:38:32 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:48686 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbXE3Gib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 02:38:31 -0400
Date: Wed, 30 May 2007 08:39:31 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tej Parkash <tejparkash.d@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: warning while building module.
Message-ID: <20070530063931.GA12203@uranus.ravnborg.org>
References: <2bd9ebfa0705282145t34ed211bs48c7b31fcd9420a5@mail.gmail.com> <20070529185725.GC5846@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529185725.GC5846@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 08:57:25PM +0200, Sam Ravnborg wrote:
> On Tue, May 29, 2007 at 10:15:58AM +0530, Tej Parkash wrote:
> > hi all
> > 
> > while building module i was getting following warning and it terminate
> > module building stage
> The below are only warnings and your build should succeed.
> 
> It is obviously i386 - is it a clean allmodconfig or any changes?
> Is it latest -linus or some older version of the codebase?
Did an allmodconfig build of i386 - I see (almost) all warnings here.
So I will take a look based on this.

The MODPOST stage took a while but it proceeded with no hick-ups.
MDOPSOT deals with ~2000 modules in my case and that consumes a bit
of memory. Maybe you are hitting the limit with respect to available RAM / SWAP?

	Sam
