Return-Path: <linux-kernel-owner+w=401wt.eu-S1760938AbYBFH4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760938AbYBFH4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 02:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759799AbYBFH4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 02:56:31 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:49674 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759318AbYBFH4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 02:56:31 -0500
Date: Wed, 6 Feb 2008 08:56:35 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] Input updates for 2.6.25-rc0
Message-ID: <20080206075635.GA6354@uranus.ravnborg.org>
References: <200802060108.31644.dtor@insightbb.com> <20080205223242.f444fad6.akpm@linux-foundation.org> <200802060149.50879.dtor@insightbb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802060149.50879.dtor@insightbb.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  
> > 
> > 
> > 
> > i8042_platform_init():
> > 
> > +#if defined(__i386__) || defined(__x86_64__)
> > 
> > use #ifdef CONFIG_X86?
> > 
> 
> I considered it but above was tested and in line with the style of the
> rest of the file...
Then please change the rest of the file so it is consistent
with the usual style to use our CONFIG_ symbols for
conditionals like the above.

	Sam
