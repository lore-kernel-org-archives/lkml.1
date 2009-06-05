Return-Path: <linux-kernel-owner+w=401wt.eu-S1752505AbZFEASo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbZFEASo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 20:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbZFEASh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 20:18:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35745
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751514AbZFEASg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 20:18:36 -0400
Date: Thu, 04 Jun 2009 17:18:36 -0700 (PDT)
Message-Id: <20090604.171836.69430669.davem@davemloft.net>
To: samuel.thibault@ens-lyon.org
Cc: torvalds@linux-foundation.org, christian@tramnitz.com, mingo@elte.hu,
       rostedt@goodmis.org, george.dunlap@eu.citrix.com, jeremy@goop.org,
       dan.magenheimer@oracle.com, avi@redhat.com,
       xen-devel@lists.xensource.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, Keir.Fraser@eu.citrix.com, gregkh@suse.de,
       kurt.hackel@oracle.com, Ian.Pratt@eu.citrix.com,
       xen-users@lists.xensource.com, ksrinivasan@novell.com,
       EAnderson@novell.com, wimcoekaerts@wimmekes.net,
       stephen.spector@citrix.com, jens.axboe@oracle.com
Subject: Re: Merge Xen (the hypervisor) into Linux
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090605000910.GQ8916@const.famille.thibault.fr>
References: <4A262F4B.8010404@tramnitz.com>
	<alpine.LFD.2.01.0906041151540.4880@localhost.localdomain>
	<20090605000910.GQ8916@const.famille.thibault.fr>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Thibault <samuel.thibault@ens-lyon.org>
Date: Fri, 5 Jun 2009 02:09:10 +0200

> Linus Torvalds, le Thu 04 Jun 2009 11:53:45 -0700, a écrit :
>> On Wed, 3 Jun 2009, Christian Tramnitz wrote:
>> >
>> > What a great idea, and while we're doing this let's also drop support
>> > for legacy stuff like PATA and i8042 in mainline. Noone will need it
>> > anyway because their successors are on the market for years... let's
>> > just take it for granted that everyone is using SATA and USB nowadays!
>> 
>> Have you noticed how PATA and i8042 don't screw up anything else? 
> 
> Right.  We should get rid of all the HIGHMEM kmap crap that cripples all
> the code.

The kmap interfaces are pretty damn clean if you ask me.  Especially
compared to the abortion Xen plops into the x86 platform code.

So, keep searching for an argument where none exists.
