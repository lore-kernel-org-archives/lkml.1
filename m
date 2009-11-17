Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbZKQTQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbZKQTQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 14:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754984AbZKQTQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 14:16:15 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:40919 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbZKQTQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 14:16:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=PKXhADaq6U4cyhlh7ffBObyWQaDtZBw36s78Ommj54W1FsKtlp8pFf3g63xjyDf/hI
         2hw+FmSMB0L/aodJaSq+uIr4TVisyXYGTUd4UAamzHGdQNrrv7rhs6iWbX0p87pszmO9
         WiPCHY+aHR4ZMg17f3cG7QwmgiEt6zXUVRx5g=
Date: Tue, 17 Nov 2009 20:16:20 +0100
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Bug #14267] Disassociating atheros wlan
Message-Id: <20091117201620.d78e350e.kristoffer.ericson@gmail.com>
In-Reply-To: <4B02F3B7.2090907@gmail.com>
References: <ipicVA1QUFF.A.zWB.1mdALB@chimera>
	<OWmO9uyC1hM.A.yiC._ndALB@chimera>
	<4B01F3FE.8040707@gmail.com>
	<20091117113320.8aef894a.kristoffer.ericson@gmail.com>
	<4B02E64D.2010700@gmail.com>
	<20091117191357.7c64ba70.kristoffer.ericson@gmail.com>
	<4B02F3B7.2090907@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Nov 2009 11:04:23 -0800
"Justin P. Mattock" <justinmattock@gmail.com> wrote:

> Kristoffer Ericson wrote:
> > On Tue, 17 Nov 2009 10:07:09 -0800
> > "Justin P. Mattock"<justinmattock@gmail.com>  wrote:
> >
> >    
> >> Kristoffer Ericson wrote:
> >>      
> >>> Im still hitting this so basicly using 2.6.30 until it get sorted. Will try and make
> >>> some time to test the different commits. Last time I waited for it to disconnect which
> >>> could take 10-40min. Since it depends on the network load Im now going to increase
> >>> the load to see if I hit it quicker (and thus finding the error commit).
> >>>
> >>> So in short, its still valid and I will try and make time to fix it :)
> >>>
> >>>
> >>>
> >>>
> >>>        
> >> o.k. so it is something that is enough to
> >> cause an inconvenience.
> >>      
> >
> > Especially if you are using your computer as a router to other computers
> > and they start screaming every time internet goes down. :(
> >
> >    
> >>      
> >
> >
> >    
> ah. yeah I'm not doing that over here
> just simply connecting to a router and streaming music.
> my guess is you can try the commits that I found
> but then again might not get you in the right
> direction i.g. during the bisect I was watching the
> "retry" in dmesg with ath* as soon as I saw that it was git bisect bad
> (seems like a new mechanism) as soon as I didn't see
> that the commit was good.
> 
> In your case you might be seeing something different(not sure though)
> because of having the computer as a router etc..

I think its related since ath was rock solid until 2.6.31. I can go 24/7 without
ever getting disconnected from wifihub with 2.6.30. If we both are experiencing 
issues post 2.6.30 atleast it should be related to same bunch of patches.
Will see if I can use gfs computer for a couple of hours tommorow
since I need to feed it with traffic. Will start with your commits, will notice
if those turn out same for me.


> 
> Justin P. Mattock


-- 
Kristoffer Ericson <kristoffer.ericson@gmail.com>
