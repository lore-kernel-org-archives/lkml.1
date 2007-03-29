Return-Path: <linux-kernel-owner+w=401wt.eu-S934193AbXC2WzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934193AbXC2WzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 18:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934359AbXC2WzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 18:55:12 -0400
Received: from smtpout.mac.com ([17.250.248.184]:55568 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934193AbXC2WzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 18:55:10 -0400
In-Reply-To: <20070329205935.GB13541@Ahmed>
References: <bc8960410703290304t7ff61205u7110ac33c671fb4d@mail.gmail.com> <2375c9f90703290332w3f232b1cjf044f554fba04879@mail.gmail.com> <20070329205935.GB13541@Ahmed>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <64884922-4254-4827-9A9F-09053043B8E6@mac.com>
Cc: Cong WANG <xiyou.wangcong@gmail.com>,
       Russ Meyerriecks <datachomper@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Student Project Ideas
Date: Thu, 29 Mar 2007 18:54:33 -0400
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 29, 2007, at 16:59:36, Ahmed S. Darwish wrote:
> On Thu, Mar 29, 2007 at 06:32:21PM +0800, Cong WANG wrote:
>> Second, in fact, I am also a college student and also want to find  
>> a suitable and real task in linux kernel for me to work on. KJ  
>> doesn't help much. ;-p
>
> No, it really helps alot, just be _patient_. For me, I sent a  
> series of dumb patches at first to use ARRAY_SIZE macro instead of  
> manual computation. Though the patches were completely braindead, I  
> learnt alot of stuff about how everything works here.

One thing that I think is fairly non-obvious to newcomers is that  
Linux kernel development is not done at all the way they teach you in  
your Large Scale Software Engineering classes.  Many of those classes  
talk much about careful design (whether top-down, bottom-up, outside- 
in, waterfall, spiral, $BUZZWORD_OF_THE_DAY) and detailed unit- 
testing, whereas Linux kernel development isn't really "designed" at  
all.

Linux is all about evolution: Somebody comes up with a design they  
like and talk about it on LKML, lots of knowledgeable people put in  
input, the design is reworked, repeat.  After a few discussion emails  
(or none at all for small projects), somebody just sits down and  
codes the damn thing.  In a business nobody does any code till they  
have the design finalized, the managers consider the extra coding a  
waste of man-hours, whereas in Linux the whole design process centers  
around writing many subtly different versions of the same thing until  
everybody agrees that it looks right.

Then it gets pulled into Andrew Mortons tree and promptly breaks all  
over the place because people try things you didn't expect.  You then  
get the opportunity to recode half the thing all over again to fix  
the newly discovered deficiencies.  Repeat several times.

After a while it stops crashing peoples boxes and goes into Linus  
tree, but at that point your job is only half done.  Now you have to  
maintain the feature, add patches, improve functionality, and  
continue to be active in the community.

Large college end-of-study projects are single-person activities,  
they want to test _your_ knowledge.  On the other hand Linux kernel  
development is a community exercise, it's trying to use the knowledge  
of thousands to build the best kernel possible.  If you can get  
approval to use the bits of code that many others contribute then  
more power to you.

The other thing to realize about Linux is that it is NOT a "hobbyist"  
OS any more, there are some extremely mission-critical Linux systems  
out in the world which depend on the code quality and efficiency.   
There are few people indeed who can really efficiently increase the  
performance of the Linux schedular or other core subsystems.  Kudos  
to Linus Torvalds, Ingo Molnar, Con Kolivas, Andrew Morton, and  
others too numerous to list for their incredible skill and dedication.

So while it's entirely possible to do innovative dissertation work on  
the Linux kernel with your own private source tree, don't expect to  
go from a cold standing start to having a big project in the upstream  
kernel without investing twice as much time as it was to do the  
dissertation in the first place.  That's not to say that you can't  
always get advice from many others on this mailing list during the  
process, though.

Cheers,
Kyle Moffett

