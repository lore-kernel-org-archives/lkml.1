Return-Path: <linux-kernel-owner+w=401wt.eu-S1757646AbYCBSHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646AbYCBSHA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 13:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbYCBSGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 13:06:52 -0500
Received: from el-out-1112.google.com ([209.85.162.179]:64561 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075AbYCBSGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 13:06:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=npF2AQvXe9RGaVqhe75sFRmE2ISrmOEOYyjfmkNsIOtP6ygRhjBjpxPgHCE+E06+uO63HWaHD6yi97GxNoVeR9e1AYbQl52JrRoYXvvjmSm0QYDqQdxYKSOouziKDj25Qe8Euc4tfCS/lNV04JAtqbONBo9Pd1RINY6RunghkQk=
Subject: Re: [PATCH] saa7146: fix sparse warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47CAE50C.2000106@gmail.com>
References: <1203616356.20345.45.camel@brick>  <47CAE50C.2000106@gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Sun, 02 Mar 2008 10:06:44 -0800
Message-Id: <1204481204.23005.8.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-03-02 at 20:34 +0300, Dmitri Vorobiev wrote:
> Harvey Harrison пишет:
> >  
> > -	if( 0 != (dev->ext)) {
> > +	if( NULL != (dev->ext)) {
> 
> At the risk of looking an idiot, I'm taking a liberty to ask what is
> the point in explicit comparison to zero in conditional operators? Is
> it not a fundamental C idiom to write

<snip>

Yes, that's how I would have written it, but I tried to keep with the
prevailing style in that file.  I suppose I could see an argument for
consistency if you had a long series of if() statements to keep a
similar style.

if (foo == value1)

if (bar == value2)

if (baz == NULL)

I'll leave the discussion of putting the constant first in the comparison
for someone else to comment on.

Harvey

