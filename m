Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879Ab0AQQHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab0AQQHh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 11:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239Ab0AQQHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 11:07:36 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:60441 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab0AQQHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 11:07:35 -0500
Message-ID: <4B5335CA.7080309@pardus.org.tr>
Date: Sun, 17 Jan 2010 18:07:38 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [0/9] 2.6.31.12-stable review
References: <20100114224848.GA532@kroah.com> <4B520D98.7030202@pardus.org.tr> <20100117032319.GA27413@kroah.com>
In-Reply-To: <20100117032319.GA27413@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sat, Jan 16, 2010 at 09:03:52PM +0200, Ozan ??a??layan wrote:
>> Greg KH wrote:

> 
> As this is going to be the last .31 release, and all users should really
> be moving to .32, I'm not going to worry about this one.  Is that ok
> with you?
> 
> thanks,

Personally I really don't like the idea of "all users should really be moving to .3x" which is true
for individual bleeding edge users which compiles and uses their own kernel but there are still distributions
around (as well as the one that I'm trying to maintain the kernel part) which ships 2.6.31.

Every distribution has a release policy and switching from .3x to .3(x+1) on the road isn't sometimes desirable because
of the regression risks. I can't risk to switch to .32 as I'm still seeing very very serious regression reports on LKML.

We just switched from 2.6.30.10 to 2.6.31.9 because I thought that it was stabilized and
I was hoping that .31 will be a long term maintained release :) Then the next day
I saw the announcement from you saying that 2.6.31.10 will be the last release of .31 series :)

I spotted 3 very annoying regressions in a 3-day period just after switching to 2.6.31:
 - boot hangs with AMD Athlon XP processors (#15075),
 - shutdown hangs on some *apparently* Pentium 4 processors (#15073),
 - Governor failures on some systems because of BUG in MCE code (#14521)

The 1st and the 3rd one were injected during 2.6.31 merge window, so they were regressions that should have been caught already
but to not fix them in 2.6.31.y would be an option as they were always in 2.6.31.y from 2.6.31 to 2.6.31.11.

*but*

The commit causing the 2nd one was accepted during 2.6.31.10 stable review. To accept a bugfix which causes a more serious regression
is somewhat inacceptable for me. You announce the end-of-life of 2.6.31 with 2.6.31.10 with a really serious regression injected.

I don't try to blame anyone as I really really appreciate the work done by all the people in this list but unless some release policy
isn't written for kernel releases, there will always be such annoyances :)

For example, I'm hopelessly waiting for a long-term-supported kernel like .27. Was it because someone liked the number 27 or something else?
Will it happen again? If yes will this decision made public before the release?

Again, please please don't take the whole e-mail personal, I'm just describing a downstream kernel package maintainer's problems :)

Thanks,
Ozan Caglayan
Pardus Linux -- http://www.pardus.org.tr/eng

