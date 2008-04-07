Return-Path: <linux-kernel-owner+w=401wt.eu-S1757396AbYDGKF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbYDGKF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 06:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbYDGKFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 06:05:17 -0400
Received: from hpsmtp-eml14.kpnxchange.com ([213.75.38.114]:57540 "EHLO
	hpsmtp-eml14.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755886AbYDGKFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 06:05:16 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [rc8] Regression: key repeats and skips in music during compilation
Date: Mon, 7 Apr 2008 12:05:12 +0200
User-Agent: KMail/1.9.9
References: <200804041222.35025.elendil@planet.nl> <200804062239.44861.rjw@sisk.pl> <200804071121.03888.rjw@sisk.pl>
In-Reply-To: <200804071121.03888.rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804071205.13369.elendil@planet.nl>
X-OriginalArrivalTime: 07 Apr 2008 10:05:13.0999 (UTC) FILETIME=[DF5D01F0:01C89896]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 April 2008, Rafael J. Wysocki wrote:
> On Sunday, 6 of April 2008, Rafael J. Wysocki wrote:
> > On Friday, 4 of April 2008, Frans Pop wrote:
> > > While compiling glibc I am getting frequent short skips in music play
> > > anddddddddddddddddd I have now three times seen key repeats (as in
> > > this sentence). When there is a skip in the music, there is also a
> > > delay in characters being typed appearing on the screen.
> >
> > Can you test with CONFIG_GROUP_SCHED unset, please?
>
> I was able to reproduce this issue with -rc8 on one of my test systems,

Thanks Rafael.

In the mean time I have verified that the issue also existed in rc6, so it's 
not a recent regression.

> but I'm not any more with the current Linus' tree and CONFIG_GROUP_SCHED
> unset, FWIW.

Hmm. Does that mean that you _can_ reproduce it with git HEAD and 
CONFIG_GROUP_SCHED set? That would mean it is still an issue in HEAD and 
group scheduling is the culprit.

I'll try to confirm that later today.

Cheers,
FJP
