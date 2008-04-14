Return-Path: <linux-kernel-owner+w=401wt.eu-S1762317AbYDNQWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762317AbYDNQWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 12:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756816AbYDNQWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 12:22:04 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:38099 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756094AbYDNQWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:22:03 -0400
Date: Mon, 14 Apr 2008 12:22:02 -0400
To: Jan Kara <jack@suse.cz>
Cc: Bodo Eggert <7eggert@gmx.de>, Diego Calleja <diegocg@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
       Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080414162202.GB7387@csclub.uwaterloo.ca>
References: <agh4d-6yc-35@gated-at.bofh.it> <ah5tY-3lR-7@gated-at.bofh.it> <ah5DA-3X9-9@gated-at.bofh.it> <ah5X5-4tl-13@gated-at.bofh.it> <ah66A-4Nk-7@gated-at.bofh.it> <ah7vN-7Wz-9@gated-at.bofh.it> <E1JkIJ0-0000tG-LV@be1.7eggert.dyndns.org> <20080411135544.GG2160@csclub.uwaterloo.ca> <20080414162031.GD15824@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414162031.GD15824@duck.suse.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 06:20:31PM +0200, Jan Kara wrote:
>   Well, as Jiri Kosina wrote, this isn't a problem unless someone finds
> a way how to use this race for some attack (and for example making f_pos
> negative compromises security so it is not so far-fetched as it would
> seem). So proactively fixing this makes some sence.

But you would have to be part of that process to affect the filehandle
wouldn't you?  If you are part of the process already wouldn't it be
easier to manipulate things directly rather than playing with the
filehandle position?

-- 
Len Sorensen
