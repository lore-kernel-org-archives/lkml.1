Return-Path: <linux-kernel-owner+w=401wt.eu-S1758763AbXE3XRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763AbXE3XRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 19:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757009AbXE3XRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 19:17:35 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:63776 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757969AbXE3XRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 19:17:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RmvEDngGwDOLvMg7J3rA0fG0bIp3cPl7u2yPKn9Z71i36RC7kNpokPfPW3N1r7q/HgKwBcGLc9W/goN3/Higb67HPnHxSDU3Dtx4o6O1aipqfI0iPnqUBSwgZJcHWgDpaquj8rCNnYM1OoItMxgtgqab5WQJNcL721EZc5pX4T8=
Subject: Re: tty-related oops in latest kernel(s)?
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Tero Roponen <teanropo@jyu.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <Pine.LNX.4.64.0705301857370.29485@jalava.cc.jyu.fi>
References: <Pine.LNX.4.64.0705271200360.4955@jalava.cc.jyu.fi>
	 <84144f020705280022lf3902caj1def02ed56e0bff@mail.gmail.com>
	 <84144f020705280234g39aa04b3hfe369f4477e6043d@mail.gmail.com>
	 <Pine.LNX.4.64.0705291900001.32656@jalava.cc.jyu.fi>
	 <84144f020705291157k465ec6c4sb81081844bb57514@mail.gmail.com>
	 <Pine.LNX.4.64.0705300654493.5241@jalava.cc.jyu.fi>
	 <84144f020705292254o319f6619m787bf29491c92509@mail.gmail.com>
	 <Pine.LNX.4.64.0705301458400.4634@jalava.cc.jyu.fi>
	 <20070530083953.9909bcef.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0705301857370.29485@jalava.cc.jyu.fi>
Content-Type: text/plain
Date: Thu, 31 May 2007 07:17:27 +0800
Message-Id: <1180567047.4570.18.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-30 at 19:01 +0300, Tero Roponen wrote:
> On Wed, 30 May 2007, Andrew Morton wrote:
> 
> > On Wed, 30 May 2007 15:02:49 +0300 (EEST) Tero Roponen <teanropo@jyu.fi> wrote:
> > 
> > > On Wed, 30 May 2007, Pekka Enberg wrote:
> > > 
> > > > On 5/30/07, Tero Roponen <teanropo@jyu.fi> wrote:

> 
> after some trial and error I found a simple way to trigger the
> corruption:
> 

BTW, that was impressive.  You exposed a long-standing bug in neofb,
thanks.

And just FYI, you can also trigger it by doing fbset -depth 24.

Tony 


