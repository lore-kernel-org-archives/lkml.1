Return-Path: <linux-kernel-owner+w=401wt.eu-S1759426AbYDJWGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426AbYDJWGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 18:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758945AbYDJWGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 18:06:08 -0400
Received: from nn7.de ([85.214.94.156]:46694 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758876AbYDJWGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 18:06:07 -0400
Subject: Re: suspend issue
From: Soeren Sonnenburg <kernel@nn7.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Justin Mattock <justinmattock@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080410100234.GB11084@ucw.cz>
References: <dd18b0c30804052103s7357bb86yf7bf11d38d2911b3@mail.gmail.com>
	 <1207490104.4597.36.camel@localhost> <20080406232849.GA789@elf.ucw.cz>
	 <1207736730.4320.1.camel@localhost>  <20080410100234.GB11084@ucw.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 11 Apr 2008 00:05:52 +0200
Message-Id: <1207865152.21472.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-10 at 12:02 +0200, Pavel Machek wrote:
> On Wed 2008-04-09 12:25:30, Soeren Sonnenburg wrote:
> > On Mon, 2008-04-07 at 01:28 +0200, Pavel Machek wrote:
> > > On Sun 2008-04-06 13:55:04, Soeren Sonnenburg wrote:
> > > > On Sun, 2008-04-06 at 04:03 +0000, Justin Mattock wrote:
> > > > > Hello; I seem to have discovered something with echo mem > /sys/power/state.
> > > > > I recompile the kernel and had forgotten to compile fglrx, when
> > > > > performing a suspend without fglrx I was confronted with the dreaded
> > > > > blank screen and a reboot. then as a test I compiled fglrx and loaded,
> > > > > and to my amazement suspend reacted properly again.
> > > > 
> > > > Yeah, but I it does not even work without X - console only!
> > > > 
> > > > s2ram -f -p used to work since at least 2.6.20 ... and is now not
> > > > anymore in 2.6.25-*
> > > 
> > > Can you do git bisect?
> > 
> > I just tried, and the problem is that 25-rc1 already fails to suspend -
> > so I am not sure how I could get more insight into this failure *on
> > resume*... any ideas?
> 
> Well, 2.6.20 worked, so bisect should be easy, right?

I don't quite understand... 2.6.24 worked yes, but 2.6.25-rc1 didn't
even *suspend*. However the problem lies not in suspending but no
display on *resume*. So the bug is hidden by the hang on suspend and I
don't see how I can check when resume broke.

Soeren
