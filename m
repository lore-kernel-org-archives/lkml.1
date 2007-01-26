Return-Path: <linux-kernel-owner+w=401wt.eu-S1161182AbXAZS7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161182AbXAZS7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:59:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161184AbXAZS7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:59:11 -0500
Received: from waste.org ([66.93.16.53]:37912 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161181AbXAZS7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:59:10 -0500
Date: Fri, 26 Jan 2007 12:46:28 -0600
From: Matt Mackall <mpm@selenic.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Andrew Morton <akpm@osdl.org>, Paul Mundt <lethal@linux-sh.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] init: support preset lpj value as config option
Message-ID: <20070126184628.GY10108@waste.org>
References: <45B7F5E2.4070800@am.sony.com> <20070125021847.GA7609@linux-sh.org> <45B8F5FB.6090704@am.sony.com> <20070126024411.4d4b6c2e.akpm@osdl.org> <45BA4884.4020205@am.sony.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BA4884.4020205@am.sony.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 10:29:24AM -0800, Tim Bird wrote:
> Andrew Morton wrote:
> >> i386 is missing CONFIG_CMDLINE support, and this architecture
> >> is used in embedded.
> > 
> > So if we add CONFIG_CMDLINE we fix this problem and we bring i386 into line
> > with other platforms.  It's all good.
> > 
> >>  I think many other x86 derivatives are
> >> also missing .config-based command line support.  CELF has
> >> worked to get patches submitted to fix this, but so far these
> >> haven't been accepted.
> > 
> > You have?
> > 
> > <looks at inbox>
> > 
> > To whom?
> 
> Matt Mackall would know better than I.  He's the person
> CELF hired to do this.  Here are some of the previous LKML
> discussions around this issue:
> 
> http://lkml.org/lkml/2006/6/11/115
> 
> http://lkml.org/lkml/2006/7/31/208
> 
> Last time I talked to Matt about this (some time in
> November, I believe), he said he had worked out a
> solution agreeable to H. Peter Anvin, who had issues
> with the original submission.  I'm not sure if that
> latest solution was submitted to mainline or not.

The idea was to allow putting something like "%s" in the built-in
command line and expanding that with the provided command line. This
allows you to append/prepend/ignore the provided command line as you
desire.

This is a fair bit more complicated than what the existing
implementations of CONFIG_CMDLINE are doing and details like
early_cmdline handling don't help matters. Haven't yet come up with an
implementation I'm happy with.

-- 
Mathematics is the supreme nostalgia of our time.
