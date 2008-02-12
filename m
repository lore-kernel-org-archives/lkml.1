Return-Path: <linux-kernel-owner+w=401wt.eu-S1761435AbYBLTiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761435AbYBLTiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbYBLTiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:38:00 -0500
Received: from mail.fieldses.org ([66.93.2.214]:33140 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbYBLTh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:37:59 -0500
Date: Tue, 12 Feb 2008 14:37:54 -0500
To: Jeff Garzik <jeff@garzik.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       John Linville <linville@tuxdriver.com>
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080212193754.GC18625@fieldses.org>
References: <20080212044314.GA4888@kroah.com> <20080211211751.3e265754@laptopd505.fenrus.org> <20080212055312.GA5631@kroah.com> <20080211.220726.157328337.davem@davemloft.net> <47B1C9F4.30402@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B1C9F4.30402@garzik.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 11:31:48AM -0500, Jeff Garzik wrote:
> David Miller wrote:
>> I rebase my tree all the time, at least once or twice per
>> week.  Why?
>>
>> Firstly, to remove crap.  When you have "great idea A" then "oh shit A
>> won't work, revert that" there is zero sense in keeping both
>> changesets around.
>>
>> Secondly, I want to fix up the rejects caused by conflicts with
>> upstream bug fixes and the like (and there are tons when the tree gets
>> to 1500 or so patches like the networking did).  I don't want git to
>> merge the thing by hand, I want to see what the conflict is and make
>> sure the "obvious" resolution is OK and the most efficient way I know
>> how to do that is to suck my tree apart as patches, then suck them
>> back into a fresh tree.
>
> FWIW, that is annoying and painful for us downstream jobbers, since it  
> isn't really how git was meant to be used.  You use it more like a patch  
> queue, where commits are very fluid.
>
> Unfortunately, if there is any synchronization lag between me and you --  
> not uncommon -- then I cannot commit changes on top of the changes just  
> sent, in my own local tree.  Why?  Because you rebase so often, I cannot  
> even locally commit dependent patches due to the end result merge  
> getting so nasty.
>
> I understand the desire to want a nice and clean history, but the  
> frequency here really has a negative impact on your downstreams.
>
> It also totally screws the commit statistics, wiping me and John and the  
> committers we have preserved out, replacing everybody's committer with  
> David Miller.

But the "author" is still preserved, right?  Why do you need the
committer name to be preserved?  (I'm not denying that there could be
reasons, I'm just curious what they are.)

--b.
