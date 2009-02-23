Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbZBWOuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbZBWOuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 09:50:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbZBWOun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 09:50:43 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:34475 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753662AbZBWOum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 09:50:42 -0500
Date: Mon, 23 Feb 2009 09:50:41 -0500
To: Richard Jonsson <richard_jonsson@hotmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Unable to write dvd+r on 3 systems
Message-ID: <20090223145041.GC23244@csclub.uwaterloo.ca>
References: <BAY108-W33A90CE987FE494CAA66779DB90@phx.gbl> <20090220170234.GA7314@csclub.uwaterloo.ca> <BAY108-W2C10388371126DA9B254C9DB10@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY108-W2C10388371126DA9B254C9DB10@phx.gbl>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 11:22:29AM +0100, Richard Jonsson wrote:
> They are present on system1, but not the other two. How can I determine if
> they interfere?

Well I have seen them interfere in some cases, but maybe it depends on
the version.  Given I hate windows popping up and auto mounting when I
insert disks, I get rid of those things in general.  At least the volume
manager is just annoying.

> Running "dd if=/dev/dvd of=/dev/null" on a burned disc reports read
> error at or around the block where the speed jumps from 2.4x> 4.0x or
> from 4.0x> 6.0x. 
> I had logs for this, but misplaced them =/. Also when jumping to
> the next higher speed there is a dip where growisofs reports 0x burn
> speed, is that normal?

On some drives I have seen that without problems.  Hard to say.

Perhaps asking the cdwrite mailing list where the growisofs developers
seem to hang out could get some better ideas.  After all they actually
know how this stuff is suppsoed to work.

-- 
Len Sorensen
