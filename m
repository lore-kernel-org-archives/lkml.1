Return-Path: <linux-kernel-owner+w=401wt.eu-S934617AbYEBNaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934617AbYEBNaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 09:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764018AbYEBNaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 09:30:09 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:43674 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764382AbYEBNaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 09:30:07 -0400
Date: Fri, 2 May 2008 15:30:05 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Chris Mason <chris.mason@oracle.com>
cc: Jeff Mahoney <jeffm@suse.com>, Tim Gardner <tim.gardner@canonical.com>,
       jeffschroeder@computer.org, linux-fsdevel@vger.kernel.org,
       kernel-team@lists.ubuntu.com, linux-kernel@vger.kernel.org,
       linux-btrfs@vger.kernel.org, John Johansen <jjohansen@suse.de>
Subject: Re: Btrfs v0.14 Released
In-Reply-To: <200805020852.51125.chris.mason@oracle.com>
Message-ID: <alpine.LNX.1.10.0805021526420.6463@fbirervta.pbzchgretzou.qr>
References: <200804291601.32945.chris.mason@oracle.com> <481A23AB.1020302@suse.com> <alpine.LNX.1.10.0805020837490.6463@fbirervta.pbzchgretzou.qr> <200805020852.51125.chris.mason@oracle.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-05-02 14:52, Chris Mason wrote:
>>
>> An alternative approach, and IMHO better suited, is to:
>>
>> 	make -C ${kdir} all I_HAZ_AN_APPARMOR=1
>
>This is better than the current situation (oops without any clues), but I'd 
>prefer that people not have to know what apparmor is or if they have it.  

I guess iff people have a clue just what btrfs is and what it is good for
and why one would need it, I guess they also know of Apparmor.
If not, well, I hope you mentioned it in the INSTALL file!
Documentation on the most important things is always a good thing.

>(This isn't a knock on apparmor, I'd just rather take care of it 
>automagically).

Well you could go down the conftest.sh route, but I dislike that
approach because such a Makefile system tries to be smarter than me;
and that often breaks because developers made a mess out of the
remaining Makefile and before long, it broke on odd, but
"standards-conforming", O= builds. (Fun stories with nvidia.)
