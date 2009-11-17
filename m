Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbZKQKlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbZKQKlD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 05:41:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbZKQKlC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 05:41:02 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:50755 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbZKQKlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 05:41:00 -0500
X-Greylist: delayed 679 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Nov 2009 05:41:00 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=Ue0DWsoH6n3sZffEaCWTSWTpLc8hlAOlqMN/d1zra5BbtfOLMZG7Ft7OjITIT3qPYM
         w2vziGIIfrtoqOw5DOpPwJJeIZZ63qSc1pSQFDfaMmdIb1oa6Q/U9sN+ZF8IdajOD7OC
         GC+X1s+NrwVCBAakU0mFXkvI91rEehG3+LMeg=
Date: Tue, 17 Nov 2009 11:33:20 +0100
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Bug #14267] Disassociating atheros wlan
Message-Id: <20091117113320.8aef894a.kristoffer.ericson@gmail.com>
In-Reply-To: <4B01F3FE.8040707@gmail.com>
References: <ipicVA1QUFF.A.zWB.1mdALB@chimera>
	<OWmO9uyC1hM.A.yiC._ndALB@chimera>
	<4B01F3FE.8040707@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Nov 2009 16:53:18 -0800
"Justin P. Mattock" <justinmattock@gmail.com> wrote:

> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.30 and 2.6.31.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> > be listed and let me know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14267
> > Subject		: Disassociating atheros wlan
> > Submitter	: Kristoffer Ericson<kristoffer.ericson@gmail.com>
> > Date		: 2009-09-24 10:16 (54 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125378723723384&w=4
> >
> >
> >
> >    
> I'm not sure(I've been procrastinating on this one
> with reverting commits to see if it helps
> the guy that reported this).
> 
>  From over here though there never was a problem
> on my side with the wireless connection(maybe a few disconnects,
> but nothing too harsh).
> 
> At this point the best thing to do is to see what the
> response is from the two gentlemen who where really
> hitting this and seem to be running into issues
> then go from there.

Im still hitting this so basicly using 2.6.30 until it get sorted. Will try and make
some time to test the different commits. Last time I waited for it to disconnect which
could take 10-40min. Since it depends on the network load Im now going to increase
the load to see if I hit it quicker (and thus finding the error commit).

So in short, its still valid and I will try and make time to fix it :)


> 
> Justin P. Mattock
> 
> 


-- 
Kristoffer Ericson <kristoffer.ericson@gmail.com>
