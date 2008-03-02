Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbYCBUIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbYCBUIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 15:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbYCBUIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 15:08:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755894AbYCBUIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 15:08:05 -0500
Date: Sun, 2 Mar 2008 11:57:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] saa7146: fix sparse warnings
Message-Id: <20080302115743.c9a0a280.akpm@linux-foundation.org>
In-Reply-To: <1204481204.23005.8.camel@brick>
References: <1203616356.20345.45.camel@brick>
	<47CAE50C.2000106@gmail.com>
	<1204481204.23005.8.camel@brick>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 Mar 2008 10:06:44 -0800 Harvey Harrison <harvey.harrison@gmail.com> wrote:

> On Sun, 2008-03-02 at 20:34 +0300, Dmitri Vorobiev wrote:
> > Harvey Harrison пишет:
> > >  
> > > -	if( 0 != (dev->ext)) {
> > > +	if( NULL != (dev->ext)) {
> > 
> > At the risk of looking an idiot, I'm taking a liberty to ask what is
> > the point in explicit comparison to zero in conditional operators? Is
> > it not a fundamental C idiom to write
> 
> <snip>
> 
> Yes, that's how I would have written it, but I tried to keep with the
> prevailing style in that file.

I'm not a bit fan of the match-the-existing-style approach.

You'll find that files which started out with a non-standard style already
contain a mixup of styles, because later changes were often made in
standard-style.

And given that we're churning the code anyway, we might as well fix it up now. 
Yes, that'll make the code look partially-weird rather than wholly-weird,
but I doubt if that will harm anyone much.

