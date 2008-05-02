Return-Path: <linux-kernel-owner+w=401wt.eu-S935012AbYEBMxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935012AbYEBMxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 08:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764070AbYEBMxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 08:53:15 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:47334 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760627AbYEBMxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 08:53:12 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Btrfs v0.14 Released
Date: Fri, 2 May 2008 08:52:50 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Jeff Mahoney <jeffm@suse.com>, Tim Gardner <tim.gardner@canonical.com>,
       jeffschroeder@computer.org, linux-fsdevel@vger.kernel.org,
       kernel-team@lists.ubuntu.com, linux-kernel@vger.kernel.org,
       linux-btrfs@vger.kernel.org, John Johansen <jjohansen@suse.de>
References: <200804291601.32945.chris.mason@oracle.com> <481A23AB.1020302@suse.com> <alpine.LNX.1.10.0805020837490.6463@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0805020837490.6463@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805020852.51125.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 May 2008, Jan Engelhardt wrote:
> On Thursday 2008-05-01 22:10, Jeff Mahoney wrote:
> >>>> Couldn't you #ifdef based on CONFIG_SECURITY_APPARMOR ? This ought to
> >>>> work for Hardy. However the next development kernel (Intrepid) does
> >>>> not have the APPARMOR patches, so just knowing that its an UBUNTU
> >>>> kernel is not specific enough.
> >>>
> >>> I've been assuming the apparmor patches change remove_suid even when
> >>> they are not enabled in the config.
> >>
> >> Lets get Kees involved. He developed the patch set for Hardy. I would
> >> hope that if CONFIG_SECURITY_APPARMOR=n then the source would default to
> >> its normal state.
> >
> >remove_suid() isn't the only change AppArmor makes to the VFS interface.
> >It's pretty invasive and requires that dentries are passed with a
> >companion vfsmount in most cases. Putting #ifdefs around all that code
> >would make the problem worse, not better.
>
> An alternative approach, and IMHO better suited, is to:
>
> 	make -C ${kdir} all I_HAZ_AN_APPARMOR=1

This is better than the current situation (oops without any clues), but I'd 
prefer that people not have to know what apparmor is or if they have it.  
(This isn't a knock on apparmor, I'd just rather take care of it 
automagically).

-chris
