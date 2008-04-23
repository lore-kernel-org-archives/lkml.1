Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbYDWQXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbYDWQXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 12:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbYDWQXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 12:23:18 -0400
Received: from hpsmtp-eml13.kpnxchange.com ([213.75.38.113]:18070 "EHLO
	hpsmtp-eml13.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751199AbYDWQXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 12:23:18 -0400
From: Frans Pop <elendil@planet.nl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [git pull] scheduler changes for v2.6.26
Date: Wed, 23 Apr 2008 18:23:14 +0200
User-Agent: KMail/1.9.9
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Richard Jonsson <richie@coderworld.net>
References: <20080419181304.GB21353@elte.hu> <200804231136.50639.elendil@planet.nl> <20080423094644.GB23293@elte.hu>
In-Reply-To: <20080423094644.GB23293@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804231823.15746.elendil@planet.nl>
X-OriginalArrivalTime: 23 Apr 2008 16:23:16.0107 (UTC) FILETIME=[559005B0:01C8A55E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 April 2008, Ingo Molnar wrote:
> another thing - Peter observed skipping on NOHZ. Does your skipping go
> away if you boot with 'nohz' and/or with CONFIG_NOHZ=y disabled in the
> .config?

Just realized that I forgot to reply to this...

Already tried that with .24 (<200804111718.56958.elendil@planet.nl>):

! On Friday 11 April 2008, Peter Zijlstra wrote:
! > I'm having some issue on my own desktop - I get occasional latencies of
! > up to 1 second! It seems to be related to NO_HZ, because when I run a
! > simple while loop to keep the cpu busy, or boot with nohz=off it
! > doesn't seem to happen.
! >
! > Could you try that, just to see if we're seeing the same thing?
!
! Booted with nohz=off, but it does not seem to make any difference for me.
! I still get the music skips and chew still gives the high latencies.
!
! $ ./chew2
! pid 31568 preempted 4022 us after 1376 us
! pid 31568 preempted 6303 us after 6177 us
! pid 31568 preempted 8836 us after 7963 us
! pid 31568 preempted 13134 us after 7903 us
! pid 31568 preempted 20533 us after 9496 us
! pid 31568 preempted 22957 us after 8556 us
! pid 31568 preempted 28693 us after 9518 us
! pid 31568 preempted 251718 us after 8485 us
