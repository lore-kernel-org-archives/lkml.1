Return-Path: <linux-kernel-owner+w=401wt.eu-S1760214AbYDSW3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760214AbYDSW3W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 18:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbYDSW3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 18:29:16 -0400
Received: from z2.cat.iki.fi ([212.16.98.133]:58626 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbYDSW3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 18:29:15 -0400
Date: Sun, 20 Apr 2008 01:29:11 +0300
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: Joe Perches <joe@perches.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Alternative implementation of the generic __ffs
Message-ID: <20080419222911.GJ3700@mea-ext.zmailer.org>
References: <alpine.DEB.1.10.0804061320470.7751@twinlark.arctic.org> <1207563950.7880.1246457209@webmail.messagingengine.com> <20080418201809.GA5036@mailshack.com> <alpine.DEB.1.10.0804181642150.6108@twinlark.arctic.org> <1208563762.10414.19.camel@brick> <alpine.DEB.1.10.0804181719390.6108@twinlark.arctic.org> <1208566724.4891.25.camel@localhost> <1208567093.10414.20.camel@brick> <alpine.DEB.1.10.0804181810500.6108@twinlark.arctic.org> <1208573728.11990.14.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208573728.11990.14.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 07:55:28PM -0700, Joe Perches wrote:
> On Fri, 2008-04-18 at 18:11 -0700, dean gaudet wrote: 
> > have you benchmarked it?
> 
> I modified Alexander's benchmark:
> http://lkml.org/lkml/2008/4/18/267
> to include 32 and 64 bit variants called smallest.
> 
> On an old ARM:

...

I am curious, why not take the code already in glibc ffs() for ARM ?
That is, if the ffs() is all that important detail in kernel ?

  /Matti Aarnio
