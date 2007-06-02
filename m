Return-Path: <linux-kernel-owner+w=401wt.eu-S1760773AbXFBO0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760773AbXFBO0X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 10:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758343AbXFBO0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 10:26:16 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:39105
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758146AbXFBO0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 10:26:16 -0400
Date: Sat, 2 Jun 2007 07:27:13 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Valdis.Kletnieks@vt.edu
cc: David Wagner <daw-usenet@taverner.cs.berkeley.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM
 hook
In-Reply-To: <14604.1180770021@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.64.0706020723030.954@asgard.lang.hm>
References: <653438.15244.qm@web36612.mail.mud.yahoo.com>
 <f3il25$pcp$1@taverner.cs.berkeley.edu> <20070524144726.GB3920@ucw.cz>
 <12508.1180719875@turing-police.cc.vt.edu>            <f3qrp6$ftn$1@taverner.cs.berkeley.edu>
 <14604.1180770021@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jun 2007, Valdis.Kletnieks@vt.edu wrote:

> On Sat, 02 Jun 2007 04:30:30 -0000, David Wagner said:
>> I don't find the Windows stuff too relevant here.
>
> I'm surprised.  The only Windows-specific thing in the whole paragraph is that
> the attack described is currently wildly successful. And there *have* been
> known exploitable bugs in the Linux version of Firefox. In other words, all the
> pieces are in place for exactly the same thing to work on Linux.
>
> The type of hardening that AppArmor can provide network-facing daemons is only
> protecting the system against attacks that aren't even a large part of the
> threat model.   Exploiting a broken PHP script? Happens all the time, and
> AppArmor can't do much for it.

actually, this is _exactly_ where AppArmor is the most useful. if the PHP 
script is restricted by AppArmor it won't be able to go out and touch 
things that it's not supposed to.

> SQL injection? Happens all the time, and it
> can't help much there either.  Systems getting pwned because the sysadmin's
> laptop got hacked? Pretty common, and another thing that AppArmor won't slow
> down. But yes, I *will* grant that the next time there's a buffer overflow in
> Apache, AppArmor will be able to help *that*....
>
>>                                                    As I understand it,
>> AppArmor isn't aimed at defending Windows desktop users; it is aimed at
>> defending Linux servers.  A pretty different environment, I'd say.
>
> The only reason you're not seeing the same exact threat model against Linux
> servers is because it's still a minority.  It's *always* been true that one of
> the most productive attacks on a server has been to find a desktop that you can
> attack, and then abuse a trust relationship from the desktop to the server (and
> has been, ever since the server was a IBM mainframe and the desktop was an RJE
> station.  Amazing how trusting OS/360 was of a card deck tossed into a remote
> card reader... :)

if you are targeting one specific company or one specific server then you 
are correct, however most attacks are not that targeted, they do things 
like useing google to find random servers that are running vunerable 
software and attack that (or just try the attack against random IP 
addresses in case it happens to be running the vunerable software)

David Lang
