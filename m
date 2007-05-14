Return-Path: <linux-kernel-owner+w=401wt.eu-S1758370AbXENEg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370AbXENEg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 00:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbXENEgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 00:36:19 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:40063 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757247AbXENEgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 00:36:19 -0400
Date: Mon, 14 May 2007 06:37:14 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: tilman@imap.cc, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.22-rc1
Message-ID: <20070514043714.GA7614@uranus.ravnborg.org>
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org> <4647569D.7010709@imap.cc> <20070513.162059.78710763.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070513.162059.78710763.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2007 at 04:20:59PM -0700, David Miller wrote:
> From: Tilman Schmidt <tilman@imap.cc>
> Date: Sun, 13 May 2007 20:19:09 +0200
> 
> > Would it be asking too much to have help texts on the following
> > new (wrt 2.6.21) configuration options?
> > 
> > ESP Scsi Driver Core (SCSI_ESP_CORE) [N/m] (NEW)
> 
> This one is a case where the option makes no sense by itself,
> it provides the core common code for other front-end drivers.
> 
> The documentation exists in those front end drivers, which
> in turn auto-matically select and enable this config option.
> 
> It would be nice if there was a Kconfig way to not provide
> this thing at all unless one of the front-ends got selected
> but on the otherhand I like how anyone can select it and thus
> test the build of it :-)
The above is almost the help entry seeked for this option.
For some this is maybe given from the option name,
but for other the above info is a help.

So either provide help or do not have the option visible.
I would prefer the first.

	Sam
