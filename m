Return-Path: <linux-kernel-owner+w=401wt.eu-S1754267AbYI3Xjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbYI3Xjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 19:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbYI3Xi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 19:38:57 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:49052 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753420AbYI3Xi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 19:38:56 -0400
Date: Mon, 29 Sep 2008 19:56:25 +0200
From: Pavel Machek <pavel@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ben Dooks <ben-linux@fluff.org>,
       Uwe Kleine-K?nig <ukleinek@strlen.de>,
       Denis Vlasenko <vda@port.imtp.ilyichevsk.odessa.ua>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] List of maintainers (draft #3)
Message-ID: <20080929175625.GA3676@ucw.cz>
References: <200202071054.g17Asst06608@Port.imtp.ilyichevsk.odessa.ua> <20080922081239.GA28726@strlen.de> <20080922091256.GH1916@fluff.org.uk> <84144f020809220223jbb71877ued9d3b2569c4cd67@mail.gmail.com> <48D7CA62.1020805@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D7CA62.1020805@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>> Figuring out whom to send a patch to is not something you can automate
>> because it not only depends on what you're changing but *how* you're
>> changing it. The classic case being that whenever you change something
>> related to RCU that's non-trivial, you almost certainly want to CC
>> Paul "RCU" McKenney. But there's no *file* or *directory* pattern that
>> can automatically tell you this.
>>
>> Furthermore, if you're hacking on a specific part of the kernel, you
>> almost certainly are doing it wrong if you don't know who the relevant
>> maintainers are. For simple janitorial patches, you probably should
>> just work out the *top-level* maintainers (davem for networking, ingo
>> et al for x86, and so on) and send the patches to them. And when these
>> simple rules fail you, fall back to patch bombing Andrew.
>>
>
> This is, of course, true; however, there are people who should *always*  
> be included when touching specific files, and this *can* be automated.  
> This is particularly so when sending out cross-architectural patchsets.
>
> So no, automation isn't a substitute for intelligence, but that doesn't  
> mean that it can't be an *assistance*.
>
> We need this.  Right now too many people screw up even the part that  
> *can* be automated.

Yes please. Manually searching MAINTAINERS is  boring and hard... 'Is
it NETWORK BLOCK DEVICE' or 'NBD'? 'ALSA' or 'ADVANCED LINUX SOUND 
SYSTEM'? ... plus if you want subsystem maintainer, search tends to
give you about 179 individual driver maintainers, first.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
