Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbYJNFrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbYJNFrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 01:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbYJNFrC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 01:47:02 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:46440 "EHLO
	QMTA02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750766AbYJNFrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 01:47:00 -0400
X-Authority-Analysis: v=1.0 c=1 a=AE1oZuSjHPYA:10 a=4XX46gVHXKYA:10
 a=KCNKYZYThYBw8LS5D5gA:9 a=nqBDwINabAp-K5Ej_0F7PKxJmjkA:4 a=MSl-tDqOz04A:10
 a=50e4U0PicR4A:10
Subject: Re: [PROBLEM] hard-lock with kmemtrace, relayfs, and splice
From: Tom Zanussi <zanussi@comcast.net>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org
In-Reply-To: <48F42A93.1040004@cs.helsinki.fi>
References: <20080923212914.GB5237@localhost>
	 <1223386477.28348.42.camel@penberg-laptop>
	 <1223623191.8959.26.camel@penberg-laptop>
	 <1223628687.8959.37.camel@penberg-laptop>
	 <1223629803.8959.40.camel@penberg-laptop>
	 <1223631723.8959.46.camel@penberg-laptop>
	 <1223701131.7489.25.camel@charm-linux>
	 <1223881068.31587.1.camel@penberg-laptop>
	 <1223957031.10883.7.camel@charm-linux>  <48F42A93.1040004@cs.helsinki.fi>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 00:46:47 -0500
Message-Id: <1223963208.10883.55.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Tue, 2008-10-14 at 08:13 +0300, Pekka Enberg wrote:
> Hi Tom,
> 
> Tom Zanussi wrote:
> > To me, that sounds like how it should work - if kmemtrace is disabled,
> > it shouldn't be logging anything, and that's in fact what I saw when
> > debugging this - it started out disabled and therefore nothing being
> > logged to relay (printks confirmed that).  When I wrote 1 to the enabled
> > file, data started getting logged to relay and to the *.out files.
> > 
> > So I don't know why the enabled state behaves the way it does, or if
> > it's unexpected, but that anyway doesn't seem like a relay problem to
> > me.
> 
> Oh, right. Looking at kmemtraced.c, we never enable kmemtrace, just 
> disable it (which doesn't make much sense). Bug in README or the code. 
> Eduard?
> 
> Btw, Tom, you can add my
> 
> Tested-by: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> to your patch if you want. Are you going to send it to Andrew or do you 
> want me to pick it up with rest of the kmemtrace patches?

If you pick it up that would be fine with me.  Here's my sob:

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

Thanks,

Tom

> 
> 		Pekka

