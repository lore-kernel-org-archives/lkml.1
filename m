Return-Path: <linux-kernel-owner+w=401wt.eu-S1762787AbXFASAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762787AbXFASAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762082AbXFASAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:00:07 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:36377
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762034AbXFASAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:00:06 -0400
Date: Fri, 1 Jun 2007 11:00:50 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Valdis.Kletnieks@vt.edu
cc: Pavel Machek <pavel@ucw.cz>,
       David Wagner <daw-usenet@taverner.cs.berkeley.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM
 hook
In-Reply-To: <12508.1180719875@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.64.0706011048550.25896@asgard.lang.hm>
References: <653438.15244.qm@web36612.mail.mud.yahoo.com> <20070529144518.GD5840@ucw.cz>
 <Pine.LNX.4.64.0705291622430.31474@asgard.lang.hm> <20070529233041.GC24200@elf.ucw.cz>
 <f3il25$pcp$1@taverner.cs.berkeley.edu>            <20070524144726.GB3920@ucw.cz>
 <12508.1180719875@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007, Valdis.Kletnieks@vt.edu wrote:

> On Thu, 24 May 2007 14:47:27 -0000, Pavel Machek said:
>> Yes, if there's significantly more remote bad guys than local bad
>> guys, and if remote bad guys can't just get some local user first, AA
>> still has some value.
>
> Experience over on the Windows side of the fence indicates that "remote bad
> guys get some local user first" is a *MAJOR* part of the current real-world
> threat model - the vast majority of successful attacks on end-user boxes these
> days start off with either "Get user to (click on link|open attachment)" or
> "Subvert the path to a website (either by hacking the real site or hijacking
> the DNS) and deliver a drive-by fruiting when the user visits the page".

and if your local non-root user can create a hard link to /etc/shadow and 
access it they own your box anyway (they can just set the root password to 
anything they want). since I don't hear about this happening there are 
other restrictions that prevent this anyway.

everyone recognises that AA has limits, but the way people are 
emphisising these acknowledged limits is beginning to sound a bit shrill.

David Lang

