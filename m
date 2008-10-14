Return-Path: <linux-kernel-owner+w=401wt.eu-S932121AbYJNHcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121AbYJNHcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 03:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760554AbYJNHac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 03:30:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:10824 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759027AbYJNHaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 03:30:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=ms3DTGksDxRiOOOM6QcyP03c0mSKu16XhdqdISmFfg//iIJQH8NkVXucKexTNYGzuQ
         9VvExqCm8tPNHk5rNmzEE3Jr2nl4jz47mtkIoWRb+d4v62zxTcAQuj5GVfRlaJcUVkxB
         xqz0nQSS50Q4+HK3OHmt6NqYY6s/S9PWUQiCU=
Date: Tue, 14 Oct 2008 10:30:33 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Tom Zanussi <zanussi@comcast.net>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] hard-lock with kmemtrace, relayfs, and splice
Message-ID: <20081014073033.GA5284@localhost>
References: <1223386477.28348.42.camel@penberg-laptop> <1223623191.8959.26.camel@penberg-laptop> <1223628687.8959.37.camel@penberg-laptop> <1223629803.8959.40.camel@penberg-laptop> <1223631723.8959.46.camel@penberg-laptop> <1223701131.7489.25.camel@charm-linux> <1223881068.31587.1.camel@penberg-laptop> <1223957031.10883.7.camel@charm-linux> <48F42A93.1040004@cs.helsinki.fi> <1223963208.10883.55.camel@charm-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223963208.10883.55.camel@charm-linux>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 12:46:47AM -0500, Tom Zanussi wrote:
> Hi Pekka,
> 
> On Tue, 2008-10-14 at 08:13 +0300, Pekka Enberg wrote:
> > Hi Tom,
> > 
> > Tom Zanussi wrote:
> > > To me, that sounds like how it should work - if kmemtrace is disabled,
> > > it shouldn't be logging anything, and that's in fact what I saw when
> > > debugging this - it started out disabled and therefore nothing being
> > > logged to relay (printks confirmed that).  When I wrote 1 to the enabled
> > > file, data started getting logged to relay and to the *.out files.
> > > 
> > > So I don't know why the enabled state behaves the way it does, or if
> > > it's unexpected, but that anyway doesn't seem like a relay problem to
> > > me.
> > 
> > Oh, right. Looking at kmemtraced.c, we never enable kmemtrace, just 
> > disable it (which doesn't make much sense). Bug in README or the code. 
> > Eduard?
> > 
> > Btw, Tom, you can add my
> > 
> > Tested-by: Pekka Enberg <penberg@cs.helsinki.fi>
> > 
> > to your patch if you want. Are you going to send it to Andrew or do you 
> > want me to pick it up with rest of the kmemtrace patches?
> 
> If you pick it up that would be fine with me.  Here's my sob:
> 
> Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> 
> Thanks,
> 
> Tom
>

Great, this makes it go swifter. I'll commit the change to
kmemtrace-user.


