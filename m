Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350AbZGTT3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbZGTT3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 15:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbZGTT3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 15:29:34 -0400
Received: from superlopez.pirispons.net ([94.23.80.139]:34959 "EHLO
	superlopez.pirispons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbZGTT3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 15:29:34 -0400
Date: Mon, 20 Jul 2009 21:29:33 +0200
From: Kiko Piris <kernel@pirispons.net>
To: Damien Wyart <damien.wyart@free.fr>
Cc: Greg KH <gregkh@suse.de>, Wolfgang Walter <wolfgang.walter@stwm.de>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: Linux 2.6.30.2: does not boot
Message-ID: <20090720192933.GA22641@superlopez.pirispons.net>
Mail-Followup-To: Damien Wyart <damien.wyart@free.fr>,
	Greg KH <gregkh@suse.de>, Wolfgang Walter <wolfgang.walter@stwm.de>,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
References: <20090720040813.GC11940@kroah.com>
 <200907201613.22483.wolfgang.walter@stwm.de>
 <20090720150916.GB10015@suse.de>
 <20090720180333.GA2905@brouette>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090720180333.GA2905@brouette>
User-Agent: Mutt
X-No-CC: Please respect my Mail-Followup-To header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I guess this could be beginning to get off-topic on lkml.

Anyway, for what it’s worth…


On 20/07/2009 at 20:03 +0200, Damien Wyart wrote:

> I am seeing a similar problem (no hang but an immediate reboot) on the
> same distro.

Exactly the same than me.

> I suspected a recent gcc 4.3 upgrade so downgraded gcc, but no luck,
> still getting the same problem.  So for now I am quite stuck, but
> there is clearly a bad problem somewhere...

I compiled 2.6.30.1 some days ago:

| $ uname -a
| Linux rompetechos 2.6.30.1 #1 SMP Fri Jul 3 16:11:06 CEST 2009 i686 GNU/Linux

| $ zcat /usr/share/doc/linux-image-2.6.30.1/buildinfo.gz 
| binutils-2.19.1-1
| dpkg-1.15.3
| dpkg-dev-1.15.3
| gcc-4:4.3.3-9
| gcc-4.1-4.1.2-26
| gcc-4.1-base-4.1.2-26
| gcc-4.2-4.2.4-6
| gcc-4.2-base-4.2.4-6
| gcc-4.3-4.3.3-13
| gcc-4.3-base-4.3.3-13
| gcc-4.4-base-4.4.0-10
| libc6-2.9-18
| libc6-dev-2.9-18
| make-3.81-6
| perl-5.10.0-23
| this was built on a machine with the kernel:
| Linux rompetechos 2.6.29.5 #1 SMP Tue Jun 16 07:03:36 CEST 2009 i686 GNU/Linux
| using the compiler:
| gcc version 4.3.3 (Debian 4.3.3-13) 

I’m suspecting libc6 (it got upgraded this month a couple of times, now
it’s at version 2.9-21).

However, I’m not daring to downgrade it, I don’t have a box handy that I
can afford to break right now.

-- 
Kiko
