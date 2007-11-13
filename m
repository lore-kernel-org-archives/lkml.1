Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbXKMLkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbXKMLkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 06:40:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbXKMLj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 06:39:56 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:34813 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812AbXKMLjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 06:39:55 -0500
Date: Tue, 13 Nov 2007 12:41:35 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: linux-kernel@vger.kernel.org, josh@freedesktop.org
Subject: Re: [2.6.24-rc2] make C=1 killed by sparse 0.4 choking on kernel/sched.c
Message-ID: <20071113114135.GA30627@uranus.ravnborg.org>
References: <47398255.3030309@imap.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47398255.3030309@imap.cc>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I don't quite know what to make of this. It looks like a bug in
> sparse, but kernel/sched.c is perhaps not quite innocent either.
> Also it doesn't seem right that the entire kernel compilation
> aborts just because of a failed sparse run.
> 
> Opinions?

With "make C=1" you can always do "make kernel/sched.o"
And then continue with "make C=1"

It is on purpose it stops so you are forced to fix your bugs.
It is not designed with sparse errors in mind :-)

	Sam
