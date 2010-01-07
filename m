Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798Ab0AGTUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab0AGTUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753778Ab0AGTU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:20:28 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47671 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab0AGTU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:20:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ULUl7sHkEyuNv0HQHrcLuvNMuMGyYThJUFyEINPS+1CNUwsvsLehfU0xnGe1Dj9dUP
         X6jymv317Niwk/Cn6SsADP7D+0TeXsn5B4vT7H+rQpvccoh0ZibGDi8p8GJF1PVsdKBP
         MolhPUa6ihzZJ3VpH0lnXmnydxhw+9yf49CHc=
Date: Thu, 7 Jan 2010 22:20:18 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       brgerst@gmail.com, hpa@zytor.com
Subject: Re: 2.6.33-rc2: Xen/Guest switching to user mode with no user page
	tables
Message-ID: <20100107192018.GB5460@lenovo>
References: <alpine.DEB.2.01.1001051649100.3483@bogon.housecafe.de> <4B4405B5.9040205@goop.org> <alpine.DEB.2.01.1001060240010.3483@bogon.housecafe.de> <20100106112133.GA5815@lenovo> <alpine.DEB.2.01.1001060434330.3483@bogon.housecafe.de> <alpine.DEB.2.01.1001071101030.3483@bogon.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1001071101030.3483@bogon.housecafe.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 11:06:15AM -0800, Christian Kujau wrote:
> On Wed, 6 Jan 2010 at 04:43, Christian Kujau wrote:
> > # git bisect good
> > 3bd95dfb182969dc6d2a317c150e0df7107608d3 is the first bad commit
> > commit 3bd95dfb182969dc6d2a317c150e0df7107608d3
> > Author: Brian Gerst <brgerst@gmail.com>
> > Date:   Wed Dec 9 12:34:40 2009 -0500
> > 
> >     x86, 64-bit: Move kernel_thread to C
> >     
> >     Prepare for merging with 32-bit.
> >     
> >     Signed-off-by: Brian Gerst <brgerst@gmail.com>
> >     LKML-Reference: <1260380084-3707-2-git-send-email-brgerst@gmail.com>
> >     Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> > 
> > :040000 040000 30b5dd4d6888694ca2967893ef3e662461fe9978 
> > 0bb5fb33914aac10aaf0344fb8cff596378be52a M      arch
> > 
> 
> ping?
> 
> 
> I'd like to revert all of Brians commits from Dec 9 12:34:4[0-4] -0500, 
> one by one, but: 
> 
> 3bd95dfb182969dc6d2a317c150e0df7107608d3 - when reverted, it won't compile
> fa4b8f84383ae197e643a46c36bf58ab8dffc95c - but now I cannot revert all the
> e840227c141116171c89ab1abb5cc9fee6fdb488   others, git won't let me.
> f443ff4201dd25cd4dec183f9919ecba90c8edc2
> df59e7bf439918f523ac29e996ec1eebbed60440
> 
> I'm pretty much offline for a week now, I just hope this won't get 
> forgotten before 2.6.33 is released.
> 
> Thanks,
> Christian.
> -- 
> BOFH excuse #191:
> 
> Just type 'mv * /dev/null'.

Hi Christian,

for the first "guilty" commit -- it seems to be innocent, at least
from the way how kernel_thread is converted into "C". Need time for
more detailed review :/

	-- Cyrill
