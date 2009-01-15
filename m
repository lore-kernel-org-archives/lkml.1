Return-Path: <linux-kernel-owner+w=401wt.eu-S1759089AbZAOJqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089AbZAOJqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 04:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754432AbZAOJqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 04:46:14 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:60884 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926AbZAOJqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 04:46:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kfOJPlzjmymdyT+OA7+ULavd4Vm7KRkPh4Wu3znVEjIqusVnt7QlnscpFJ3TtjsXsQ
         ZF/sxhueEDhh2c7YZ50FN6spH/ur2wUH7rnymE/NtahbJi57QZlU81riLit4JjkXPwmC
         33Ayu7IJbI7yh6DA+8VqdgFjhCMp/6vOokvQo=
Date: Thu, 15 Jan 2009 09:45:30 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Chris Caputo <ccaputo@alt.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Denys Fedoryschenko <denys@visp.net.lb>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Badalian Vyacheslav <slavon@bigtelecom.ru>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: deadlocks if use htb
Message-ID: <20090115094530.GG4190@ff.dom.local>
References: <20081010090426.GA6054@ff.dom.local> <Pine.LNX.4.64.0901110438050.16453@nacho.alt.net> <20090114063909.GA4234@ff.dom.local> <200901141417.58667.denys@visp.net.lb> <1231937404.14825.4.camel@laptop> <Pine.LNX.4.64.0901141748300.17915@nacho.alt.net> <20090115065322.GA4190@ff.dom.local> <Pine.LNX.4.64.0901150724000.20461@nacho.alt.net> <20090115075450.GB4190@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090115075450.GB4190@ff.dom.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 07:54:50AM +0000, Jarek Poplawski wrote:
> On Thu, Jan 15, 2009 at 07:26:28AM +0000, Chris Caputo wrote:
> > On Thu, 15 Jan 2009, Jarek Poplawski wrote:
> > > On Wed, Jan 14, 2009 at 06:02:04PM +0000, Chris Caputo wrote:
> > > ...
> > > > That said, I would not recommend just the three for -stable unless they 
> > > > get a much wider amount of testing, on multiple platforms.  I don't see 
> > > > that as likely to happen, plus Peter says they are incomplete, so maybe it 
> > > > is just best to recommend that 2.6.28 users getting crashes while using 
> > > > HTB try these specific patches at first, and then the rest of the patches 
> > > > if they do not work.
> ...
> > I hope you can forgive me, but since I have something that works on a 
> > production machine, I am not in a position in which I can test this.
> 
> So, IOW, you don't recommend Peter's patches but prefere to use them,
> and recommend my patches, but you are afraid of using them...

Sorry, Chris! It looks like I misunderstood, and you recomend Peter's
patches yet. (But I guess there are users relying on official kernel
versions.)

I hope you can forgive me,
Jarek P.
