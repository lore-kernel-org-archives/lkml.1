Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbXIOSIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbXIOSIx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 14:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbXIOSIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 14:08:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49252 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194AbXIOSIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 14:08:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [3/3] 2.6.23-rc6: known regressions v2
Date: Sat, 15 Sep 2007 20:20:31 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
       Arkadiusz Miskiewicz <arekm@maven.pl>, Thomas Voegtle <tv@lio96.de>,
       Soeren Sonnenburg <kernel@nn7.de>
References: <46EB3EF8.6040103@googlemail.com> <46EB4374.50104@googlemail.com>
In-Reply-To: <46EB4374.50104@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709152020.33179.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 15 September 2007 04:29, Michal Piotrowski wrote:
> Hi all,
> 
> Here is a list of some known regressions in 2.6.23-rc6.
> 
> Feel free to add new regressions/remove fixed etc.
> http://kernelnewbies.org/known_regressions
> 
> List of Aces
> 
> Name                    Regressions fixed since 21-Jun-2007
> Adrian Bunk                            10
> Andi Kleen                             7
> Linus Torvalds                         6
> Alan Stern                             5
> Hugh Dickins                           5
> Trond Myklebust                        5
> Andrew Morton                          4
> David S. Miller                        4
> Al Viro                                3
> Alexey Starikovskiy                    3
> Cornelia Huck                          3
> Jens Axboe                             3
> Stephen Hemminger                      3
> Tejun Heo                              3
> 
> 
> 
> Power management
> 
> Subject         : powersaving degradation, (time spend in C0 goes up after a while)
> References      : http://lkml.org/lkml/2007/9/2/142
> Last known good : ?
> Submitter       : Christian Leber <christian@leber.de>
> Caused-By       : ?
> Handled-By      : ?
> Status          : unknown
> 
> Subject         : something broke resume from s2ram on mbp c1d (??? :))
> References      : http://lkml.org/lkml/2007/8/28/67
> Last known good : 2.6.23-rc3
> Submitter       : Soeren Sonnenburg <kernel@nn7.de>
> Caused-By       : ?
> Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
> Status          : unknown

Soeren said he would bisect, but I guess he didn't have the time.

> Subject         : 2.6.23-rc2 swsusp, suddenly increased uptime
> References      : http://lkml.org/lkml/2007/8/12/249
> Last known good : ?
> Submitter       : Thomas Voegtle <tv@lio96.de>
> Caused-By       : ?
> Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
> Status          : problem is being debugged

This is hard to reproduce, AFAICS, and unreproducible on any boxes I have
access to.
 
> Subject         : resume from ram much slower
> References      : http://lkml.org/lkml/2007/8/10/275
> Last known good : 2.6.23-rc1 ?
> Submitter       : Arkadiusz Miskiewicz <arekm@maven.pl>
> Caused-By       : ?
> Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
> Status          : problem is being debugged

Unresolved, bisection might be helpful.

Greetings,
Rafael
