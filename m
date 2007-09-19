Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbXISHcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbXISHcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 03:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbXISHci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 03:32:38 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:45876 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbXISHci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 03:32:38 -0400
Date: Wed, 19 Sep 2007 09:34:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1 - Mostly working, with a kbuild oddity
Message-ID: <20070919073402.GA32218@uranus.ravnborg.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <7319.1190143977@turing-police.cc.vt.edu> <20070918203239.GB27836@uranus.ravnborg.org> <15592.1190153008@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15592.1190153008@turing-police.cc.vt.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 06:03:28PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 18 Sep 2007 22:32:39 +0200, Sam Ravnborg said:
> 
> > So the external module were fiddeling with CFLAGS which is wrong.
> > Yes - it worked before by accident.
> 
> OK, I can deal with that diagnosis. ;)
> 
> > Pelase ask the author of the module to either fix it or even better
> > submit the driver for inclusion because then we will find it during
> > the review pahse.
> 
> I'll take it up with the author, and see what happens...
> 
> > But anyway - thanks for reporting an issue related to an external module.
> 
> I had a few issues with some other modules, but they're evil binaries so
> I'm taking those up directly with the companies involved.. ;)

How annoying is this - and is this the CFLAGS thing again?
We could introduce some workaraound so we continue to respect
the CFLAGS settings in a Makefile for a while.
But at the end of the day we should convince the external module people
to follow the Kbuild docs. So it will then be temporary.

Opinion?

	Sam
