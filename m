Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbYGRIcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbYGRIcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 04:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbYGRIcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 04:32:09 -0400
Received: from main.gmane.org ([80.91.229.2]:37045 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbYGRIcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 04:32:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: el es <el_es_cr@yahoo.co.uk>
Subject: Re: Kernel version : what about s.yy.ww.tt scheme ?
Date: Fri, 18 Jul 2008 08:31:48 +0000 (UTC)
Message-ID: <loom.20080718T075647-205@post.gmane.org>
References: <loom.20080717T083755-676@post.gmane.org> <alpine.DEB.1.10.0807171558450.17859@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 81.151.87.91 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.16) Gecko/20080702 Firefox/2.0.0.16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 <david <at> lang.hm> writes:


> 
> it means that you cannot know what version of the kernel you are getting 
> ready to release.

Yes, but when it is at large, everybody would know at a first glance, when it
was released.

> 
> today we can talk that we are working on 2.6.27 or 'this feature was 
> accepted and will be in 2.6.27' any scheme that uses the date of the 
> release means that we can't do this.
> 

With current scheme you say 'it will be in next stable mainline', not telling
any predictions when will it happen, as the stable number is only an increment,
not bound to anything but the cycle. Which many people do not understand and/or
do not want to. My numbering is not the date of _projected_ release, but the
actual date (week) when the release happened. And then, the actual week when the
stable hit large.

> I see this as a big problem with a fine-grained date scheme.
> 
> if we use the year in a date-based scheme and have a near end-of-year 
> release slip into the next year (2008.4 is released in Jan 2009) I don't 
> see this as a major problem (the bulk of the work was done in 2008 even if 
> the final release hit in 2009) under the current development cycle it's 
> not like this will end up with 'version 2009.2 released in 2011' type 
> emberrasements.

Yes, my numbering addresses this issue. It is the actual date of release,
encoded week-wise. Any development that is not expected to be 'stable' happens
in 2.mm.ww-rcX where ww is the _last_ stable mainline, frozen. Then, at first
glance you can tell 'Oh, your tree is 3 months older than mine, please rebase
before I pull it' or 'Oh, I need to rebase my tree 'cause I haven't done that
for 4 months' sort of things. Even the automated tools have it easier to tell
you when you push a tree 'Your tree is soooo out of date. Do you really want to
push your stale code to somebody else ?' or 'That tree you're pulling, was last
rebased on code created last year. You sure you want it ?'. Just hypothetically.

> 
> David Lang
> 

el es
[the 'what' in the topic is a thinko, but I don't want to spoil the thread]


