Return-Path: <linux-kernel-owner+w=401wt.eu-S1756968AbXFUTaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968AbXFUTaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbXFUTaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:30:07 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:47219
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbXFUTaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:30:05 -0400
Date: Thu, 21 Jun 2007 12:30:08 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Pavel Machek <pavel@ucw.cz>
cc: Lars Marowsky-Bree <lmb@suse.de>, Crispin Cowan <crispin@novell.com>,
       Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
In-Reply-To: <20070621183311.GC18990@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0706211136520.31603@asgard.lang.hm>
References: <20070514110607.549397248@suse.de> <200706090003.57722.agruen@suse.de>
 <20070609001703.GA17644@kroah.com> <466C303E.5010304@novell.com>
 <20070615165054.GA11345@kroah.com> <20070615200623.GA2616@elf.ucw.cz>
 <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com>
 <20070616000251.GG2616@elf.ucw.cz> <20070621160840.GA20105@marowsky-bree.de>
 <20070621183311.GC18990@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007, Pavel Machek wrote:

>> If that is the only way to implement AA on top of SELinux - and so far,
>> noone has made a better suggestion - I'm convinced that AA has technical
>> merit: it does something the on-disk label based approach cannot handle,
>> and for which there is demand.
>
> What demand? SELinux is superior to AA, and there was very little
> demand for AA. Compare demand for reiser4 or suspend2 with demand for
> AA.

well, if you _really_ want people who are interested in this to do weekly 
"why isn't it merged yet you $%#$%# developers" threads that can be 
arranged.

the people who want this have been trying to be patient and let the system 
work. if it takes people being pests to get something implemented it can 
be done, but I don't think other people on the list will appriciate this.

>> The code has improved, and continues to improve, to meet all the coding
>> style feedback except the bits which are essential to AA's function
>
> Which are exactly the bits Christoph Hellwig and Al Viro
> vetoed. http://www.uwsg.iu.edu/hypermail/linux/kernel/0706.1/2587.html
> . I believe it takes more than "2 users want it" to overcome veto of
> VFS maintainer.

so you are saying that _any_ pathname based solution is not acceptable to 
the kernel, no matter what?

David Lang
