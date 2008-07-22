Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbYGVPSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbYGVPSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 11:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYGVPSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 11:18:23 -0400
Received: from main.gmane.org ([80.91.229.2]:52638 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbYGVPSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 11:18:22 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: el es <el_es_cr@yahoo.co.uk>
Subject: Re: Kernel version : what about YYYY.MM.[01].x ?
Date: Tue, 22 Jul 2008 15:18:05 +0000 (UTC)
Message-ID: <loom.20080722T150815-360@post.gmane.org>
References: <loom.20080717T083755-676@post.gmane.org> <alpine.DEB.1.10.0807171558450.17859@asgard.lang.hm> <20080718152456.GA27729@miggy.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 81.151.128.130 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.16) Gecko/20080702 Firefox/2.0.0.16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Athanasius <link <at> miggy.org> writes:

> 
> 1) Need to clearly designate
>         a) A fresh stable release
>         b) Also updates to that stable release, without getting confused
>            with any development releases.
>         c) A fresh development release/pre-release of next stable, without
>            getting confused with current stable releases.
> 
> 2) The only real objection to the status quo seems to be "the 3rd number
> is getting too big".  This is highly subjective and not a good enough
> reason by itself to change the scheme.
> 
> 3) It would be nice for stable releases to encode when their initial
> version was made.  This gives extra information in the version number
> without having to do a lookup.  The problem with this is you don't know
> when the next stable release will actually be.  

I'd agree up to this point. But you really _do_not_ want to predict 'when the
next stable release will be' 'cause this puts pressure on people, and the
current model works good _because_ there is little pressure... If it stops being
fun, some really valuable people could go somewhere else... guess where ?

>   But -rcX is just one way of doing it, all we really need is for it to
> be clear if a version is part of development or part of a stable
> release.
> 
No, the -rcX _is_ good and worth keeping. And the 

> I therefore propose the form YYYY.MM.[sd].x

And this is where I disagree completely. You got rid of the traditional series
designator ('s=2' in my scheme), you've lengthened the year part unnecessarily.
Month is too rough grained, that's why I proposed week as a base.

> 
> So, 2.6.26 would have been 2008.07.s.0
> 
> The first update to it would be 2008.07.s.1
> 
> So, YYYY.MM.[0|1].x gives us:
> 
>         1) Clear indication of when this stable series started.
>         2) Clear indication of updates to that stable version.
>         3) Clear designation of the development versions started after
>         that stable release.

It revamps the current scheme too much - I have only 'abused' it, you've got rid
of it completely...

> 
> This not only allows someone to see how long the current
> development cycle has been going (to within +/- 4 weeks), but also
> allows a glance at all prior versions to show how quickly development
> progresses on average between stable versions.

That's why I think week based grain is better..

el es



