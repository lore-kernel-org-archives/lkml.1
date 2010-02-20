Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab0BTLUT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 06:20:19 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:49519 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab0BTLUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 06:20:17 -0500
Subject: Re: sysfs lockdep complaint
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <2375c9f91002200126x22b262b3r8b9b58e3cee34077@mail.gmail.com>
References: <1266485543.6539.4.camel@jlt3.sipsolutions.net>
	 <2375c9f91002200126x22b262b3r8b9b58e3cee34077@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Feb 2010 12:20:14 +0100
Message-ID: <1266664814.11514.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-20 at 17:26 +0800, Américo Wang wrote:
> On Thu, Feb 18, 2010 at 5:32 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > Get this when powernowd starts on my G5:
> >
> > [   30.490674] =============================================
> > [   30.490708] [ INFO: possible recursive locking detected ]
> > [   30.490727] 2.6.33-rc8-wl-64012-g6917413 #160
> > [   30.490744] ---------------------------------------------
> > [   30.490763] powernowd/2577 is trying to acquire lock:
> > [   30.490782]  (s_active){++++.+}, at: [<c0000000001efa94>]
> .sysfs_addrm_finish+0x58/0xc0
> > [   30.490831]
> > [   30.490833] but task is already holding lock:
> > [   30.490854]  (s_active){++++.+}, at: [<c0000000001eff80>]
> .sysfs_get_active_two+0x3c/0x84
> > [   30.490895]
> 
> This should be fixed by the patchset from Eric:
> 
> http://lkml.org/lkml/2010/2/11/334

Oh wow, well ..... I get like a thousand of these now:

BUG: key c0000002165eb478 not in .data!

instead of the lockdep complaint above.

johannes

