Return-Path: <linux-kernel-owner+w=401wt.eu-S1755706AbYEYPFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbYEYPFt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 11:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbYEYPFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 11:05:20 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:59754 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853AbYEYPFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 11:05:18 -0400
Date: Sun, 25 May 2008 17:04:44 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ayaz Abdulla <aabdulla@nvidia.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH 0/4] Fix forcedeth hibernate/wake-on-lan problems
Message-ID: <20080525150444.GA29739@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ayaz Abdulla <aabdulla@nvidia.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Stephen Hemminger <shemminger@linux-foundation.org>
References: <20080518125715.GA19229@yamamaya.is-a-geek.org> <20080518150908.GA4606@yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080518150908.GA4606@yamamaya.is-a-geek.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Diedrich wrote:

> First Windoze:
> Windoze, Standby (equiv. to Linux 'mem' state):  WOL borked, resumes fine
> Windoze, Hibernate: WOL borked, resumes fine

I have to correct myself on this:
I ran the above test an a japanese version of Windows (where I have
some difficulty reading all the technical texts)
I've retested this on an english version of Windows and
found that I accidentally enabled one checkbox, which said:
"Only allow management stations to bring the computer out of standby"

If I disable that one, I can wakeup the machine without problems.

So my BIOS is not as borked as I thought and it should be possible
to wake up the machine even with platform.  Further debugging will
have to wait until at least next weekend though (maybe longer)...

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
