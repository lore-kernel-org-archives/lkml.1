Return-Path: <linux-kernel-owner+w=401wt.eu-S1753698AbZEDLIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbZEDLIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 07:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbZEDLIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 07:08:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47918 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbZEDLIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 07:08:12 -0400
Date: Mon, 4 May 2009 13:12:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux-kernel <linux-kernel@vger.kernel.org>, rjw@sisk.pl
Subject: Re: compat ioctl32 for /dev/snapshot?
Message-ID: <20090504111243.GH23223@one.firstfloor.org>
References: <49FEB572.4010909@msgid.tls.msk.ru> <87prepgqhc.fsf@basil.nowhere.org> <49FEC98E.4050906@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49FEC98E.4050906@msgid.tls.msk.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 02:55:10PM +0400, Michael Tokarev wrote:
> Andi Kleen wrote:
> >Michael Tokarev <mjt@tls.msk.ru> writes:
> >
> >>Is there any reason why 32-bit uswsusp &Friends does not work
> >>on 64bits kernel?
> >>
> >>For one, 32bits s2disk produces the following when trying to
> >>suspend:
> >>
> >> ioctl32(s2disk:4134): Unknown cmd fd(4) cmd(400c330d){t:'3';sz:12} 
> >> arg(ff853554) on /dev/snapshot
> >> ioctl32(s2disk:4134): Unknown cmd fd(4) cmd(4004330a){t:'3';sz:4} 
> >> arg(00000805) on /dev/snapshot
> >>
> []
> >It's probably just that nobody has written the code yet. In general all
> >missing compat_ioctls are bugs.
> 
> Oh well.
> 
> Is the following patch ok?  I just pulled all the SNAPSHOT_* stuff from

You should ask Rafael (cc'ed) who maintains that code.
> 
> I can't test it so far, because uswsusp tools are broken in mixed
> 32/64bit case in other places.  But at least it compiles fine and
> does not complain anymore.

It would be good to test before merging.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
