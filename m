Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbXFIQsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbXFIQsP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 12:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755280AbXFIQr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 12:47:58 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:49237
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771AbXFIQr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 12:47:56 -0400
Date: Sat, 9 Jun 2007 09:46:40 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Kyle Moffett <mrmacman_g4@mac.com>
cc: Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, Pavel Machek <pavel@ucw.cz>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
In-Reply-To: <23C85F2D-9715-4C9B-BD4D-B7186A71F33D@mac.com>
Message-ID: <Pine.LNX.4.64.0706090930380.6313@asgard.lang.hm>
References: <20070514110607.549397248@suse.de> <200706042303.28785.agruen@suse.de>
 <1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil> <200706090003.57722.agruen@suse.de>
 <20070609001703.GA17644@kroah.com> <Pine.LNX.4.64.0706082207260.6675@asgard.lang.hm>
 <23C85F2D-9715-4C9B-BD4D-B7186A71F33D@mac.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007, Kyle Moffett wrote:

> On Jun 09, 2007, at 01:18:40, david@lang.hm wrote:
>> SELinux is like a default allow IPS system, you have to describe EVERYTHING 
>> to the system so that it knows what to allow and what to stop.
>
> WRONG.  You clearly don't understand SELinux at all.  Try booting in 
> enforcing mode with an empty policy file (well, not quite empty, there are a 
> few mandatory labels you have to create before it's a valid policy file). 
> /sbin/init will load the initial policy, attempt to re-exec() itself... and 
> promptly grind to a halt.  End-of-story.

sigh,
   two paragraphs below what you quoted I acknowledged exactly what you 
state. however since you must tag everything before you turn on any 
security it seems to me that you have to define everything, which is a 
similar amount of work as you would have to do for a default allow policy.

> Typical "targetted" policies leave all user logins as unrestricted, adding 
> security for daemons but not getting in the way of users who would otherwise 
> turn SELinux off.  On the other hand, a targeted policy has a "trusted" type 
> for user logins which is explicitly allowed access to everything.

Ok, it sounds as if I did misunderstand SELinux. I thought that by 
labeling the individual files you couldn't do the 'only restrict apache' 
type of thing.

> That said, if you actually want your system to *work* with any default-deny 
> policy then you have to describe EVERYTHING anyways.  How exactly do you 
> expect AppArmor to "work" if you don't allow users to run "/bin/passwd", for 
> example.

for AA you don't try to define permissions for every executable, and ones 
that you don't define policy are unrestricted.

so as I understand this with SELinux you will have lots of labels around 
your system (more as you lock down the system more) you need to define 
policy so that your unrestricted users must have access to every label, 
and every time you create a new label you need to go back to all your 
policies to see if the new label needs to be allowed from that policy

is this correct?

David Lang

