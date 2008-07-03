Return-Path: <linux-kernel-owner+w=401wt.eu-S1757103AbYGCMjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103AbYGCMjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbYGCMiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:38:55 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:50148 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbYGCMiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:38:54 -0400
Message-ID: <486C8F9C.7080507@keyaccess.nl>
Date: Thu, 03 Jul 2008 10:36:44 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Brownell <david-b@pacbell.net>, Michael Buesch <mb@bu3sch.de>,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] gpiolib: Allow user-selection
References: <200807022346.53222.mb@bu3sch.de>	<20080702170431.56d4c929.akpm@linux-foundation.org>	<200807022200.49428.david-b@pacbell.net> <20080702220842.44364045.akpm@linux-foundation.org>
In-Reply-To: <20080702220842.44364045.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03-07-08 07:08, Andrew Morton wrote:

> But what I am repeatedly seeing is people cheerfully raising 2.6.27 
> patches against the 2.6.26 tree when we have a nice 2.6.27 tree for 
> developing against.  Those days are over, guys.
> 
> I'm also seeing obvious signs that developers aren't _testing_ their 
> new code within the context of the 2.6.27 tree.  They're obviously 
> testing their stuff against 2.6.26 and then hoping and praying, only
> it doesn't always work out for them.

Developing against -next is even worse than developping against an -rc1. 
You normally want to be running the code you develop meaning you'd very 
frequently drown in everyone else's bugs without getting to your own if 
you do. Development needs to happen against something relatively stable 
really and the last release would generally seem to be the best choice.

Now ofcourse, _porting_ it to -next before submitting makes lots of 
sense but positioning -next as THE devel tree a bit less I feel...

Rene.
