Return-Path: <linux-kernel-owner+w=401wt.eu-S1752389AbYIIXxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbYIIXxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 19:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbYIIXxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 19:53:37 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:59950 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbYIIXxh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 19:53:37 -0400
X-Greylist: delayed 990 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2008 19:53:36 EDT
Subject: Re: [PATCHSCRIPT] MAINTAINERS: sort and merge P and M fields
From: Paul Bolle <pebolle@tiscali.nl>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080908221139.GA10991@cassiopeia.tralala>
References: <20080908221139.GA10991@cassiopeia.tralala>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Sep 2008 01:37:02 +0200
Message-Id: <1221003422.3604.14.camel@test.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-09 at 00:11 +0200, Uwe Kleine-König wrote:
> some time ago I sent two patch scripts to LKML that changed the
> MAINTAINERS file.  One fixed the alphabetic ordering and another
> merged the P and M fields to ease copy'n'paste.
> 
> See
> 	http://thread.gmane.org/gmane.linux.kernel/702194
> for the details.

If the MAINTAINERS file in the repository mentioned in that thread
(http://www.modarm9.com/git/people/ukleinek/linux-2.6.git?a=shortlog;h=refs/heads/maintainers) is the result of the current script, you need to clean up some of the results of merging the P and M fields (false positives not removed):
$ grep "P:.*," MAINTAINERS 
P:	Cirrus Logic Corporation (kernel 2.2 driver) <Cirrus Logic
Corporation, Thomas Woller <twoller@crystal.cirrus.com>>
P:	Hans Verkuil, Andy Walls <hverkuil@xs4all.nl, awalls@radix.net>
P:	Digi International, Inc <Eng.Linux@digi.com>
P:	Mike Halcrow, Phillip Hellewell <mhalcrow@us.ibm.com,
phillip@hellewell.homeip.net>
P:	Christopher Hoover <ch@murgatroid.com, ch@hpl.hp.com>
P:	Stephen Tweedie, Andrew Morton <sct@redhat.com,
akpm@linux-foundation.org, adilger@sun.com>
P:	Stephen Tweedie, Andrew Morton <sct@redhat.com,
akpm@linux-foundation.org, adilger@sun.com>
P:	Kristian Hoegsberg, Stefan Richter <krh@redhat.com,
stefanr@s5r6.in-berlin.de>
P:	Jean Delvare (PC drivers, core) <khali@linux-fr.org>
P:	Stephen Tweedie, Andrew Morton <sct@redhat.com,
akpm@linux-foundation.org>
P:	Wong Hoi Sing, Edison <hswong3i@gmail.com>
P:	Hung Hing Lun, Mike <hlhung3i@gmail.com>
P:	Carlos Aguiar, Anderson Briglia and Syed Khasim
<linux-omap-open-source@linux.omap.com (subscribers only)>

Regards,


Paul Bolle

