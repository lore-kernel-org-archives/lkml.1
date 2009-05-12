Return-Path: <linux-kernel-owner+w=401wt.eu-S1758469AbZEMAOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469AbZEMAOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754387AbZEMAN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:13:58 -0400
Received: from blaine.gmane.org ([80.91.229.8]:57879 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377AbZEMAN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:13:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Y4TQLlzcrqeTVOrOftZ70IGA2/eV05NeaI8nRgZP/UbnoZ65cwd/7Cv7LpHY0doftV
         4sGj6B7Ba1MSy23E/5pozr9L49uSoe0zWN0Qdeg73J+1t2xqI3BgQ7Zyotd0IJ/Dafvl
         GWV6Tx40O8v8OvSdf3wZs1h66go7a5Pyr83k0=
Subject: Re: ath9k seems to be broken on 2.6.30-rc4 with a macbook pro
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       Evgeni Golov <sargentd@die-welt.net>,
       Jiri Slaby 
	<public-jirislaby-Re5JQEeQqe8AvxtiuMwx3w@hugh.gmane.org>,
       Justin Mattock 
	<public-justinmattock-Re5JQEeQqe8AvxtiuMwx3w@hugh.gmane.org>,
       Linux Kernel Mailing List 
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
       public-ath9k-devel-xDcbHBWguxHbcTqmT+pZeQ@hugh.gmane.org,
       public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org
In-Reply-To: <1242169748.14227.15.camel@johannes.local>
References: <dd18b0c30905111002y4aeb2033ma2fbb2730f5acdaf@mail.gmail.com>
	 <4A089E49.7080403@gmail.com> <20090512103905.0D68E1FD10@chi.die-welt.net>
	 <dd18b0c30905120728v156d4e1g808a853d23ba0ae6@mail.gmail.com>
	 <20090512174636.8EBDA1FD10@chi.die-welt.net>
	 <dd18b0c30905121304k6df44362v76e8e7ae6da3b76f@mail.gmail.com>
	 <43e72e890905121601y59de3d3fh9eca4637883c37fa@mail.gmail.com>
	 <1242169748.14227.15.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 12 May 2009 16:36:36 -0700
Message-Id: <1242171396.2159.7.camel@unix>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2009-05-13 at 01:09 +0200, Johannes Berg wrote:
> On Tue, 2009-05-12 at 16:01 -0700, Luis R. Rodriguez wrote:
> 
> > > O.K. after trial and error reverting this:
> > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=47afbaf5af9454a7a1a64591e20cbfcc27ca67a8;hp=853da11b94e674445e93660f47a5f0aeeea09623
> > >
> > > brings life back to the macbook with 2.6.30-rc4
> > > (not sure about the iphone anomaly though, I'll keep
> > > an eye on that)
> > 
> > Odd.. are you changing TX power through wext? Because that 47afbaf5
> > should only make a difference when using manual tx power setting.
> 
> Except it introduced a bug which got fixed in -rc5.
> 
> johannes

No,
I try to leave the setting as is.(TX power)

If this is fixed with the latest, then I'll just
go ahead and pull when I get a chance(rather than have
the reverted stuff).

aside from that it interesting, my other machine
(imac) runs fine with ndiswrapper, and wl.

In any case I'll send a post if there's any issues.
(right now watching some hulu recommend session 9 good
flick)

Justin P. Mattock


