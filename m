Return-Path: <linux-kernel-owner+w=401wt.eu-S1764512AbYBVJib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764512AbYBVJib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 04:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbYBVJiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 04:38:23 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53957 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbYBVJiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 04:38:22 -0500
Message-ID: <47BE9872.5090706@firstfloor.org>
Date: Fri, 22 Feb 2008 10:40:02 +0100
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Mikael Pettersson <mikpe@it.uu.se>, Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexey Dobriyan <adobriyan@openvz.org>
Subject: Re: [PATCH] Make sysctl a separate filesystem
References: <47B56BF2.4020600@openvz.org> <p73ejbe1ook.fsf@bingen.suse.de> <18357.30971.334517.722985@harpo.it.uu.se> <20080222012530.GD27894@ZenIV.linux.org.uk>
In-Reply-To: <20080222012530.GD27894@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Fri, Feb 15, 2008 at 12:35:23PM +0100, Mikael Pettersson wrote:
>> Andi Kleen writes:
>>  > Pavel Emelyanov <xemul@openvz.org> writes:
>>  > >    this subdir;
>>  > > 3. sysctl inodes are now smaller than the procfs ones.
>>  > 
>>  > That's always a good thing.
>>  > 
>>  > > Note: update your initscripts to mount sysctl filesystem 
>>  > > right after the proc is mounted in order not to lose your
>>  > > /etc/sysctl.conf configuration (and optionally fstab).
>>  > 
>>  > That will break about everybody's init scripts I suspect.
>>  > 
>>  > I think you would need to go through some deprecation
>>  > period for this at least, with printks warning people
>>  > to fix their init scripts.
>>  > 
>>  > Or better find some way to do the mount automatically.
>>
>> Doing it automatically is the only acceptable way, IMO.
> 
> When and where?

Al, how would you solve the problem?

-Andi


