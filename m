Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbZBZVsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbZBZVsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 16:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbZBZVsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 16:48:33 -0500
Received: from hpsmtp-eml19.KPNXCHANGE.COM ([213.75.38.84]:1586 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751491AbZBZVsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 16:48:33 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28, rlimits, performance and debian etch
Date: Thu, 26 Feb 2009 22:48:25 +0100
User-Agent: KMail/1.9.9
Cc: libpam-modules@packages.debian.org, debian-admin@lists.debian.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902262248.26713.elendil@planet.nl>
X-OriginalArrivalTime: 26 Feb 2009 21:48:27.0355 (UTC) FILETIME=[F4D0F2B0:01C9985B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Langasek wrote:
> It has already been mentioned that this does not apply to the upcoming
> Debian 5.0 release (lenny); this patch is only present in the 4.0
> release (etch), it was actually fixed in the development series to not
> use RLIM_INFINITY *because* previous kernels didn't support this and
> would cause pam_limits to throw log warnings.

I've just migrated my home servers from Debian etch to lenny and bind9 now 
gives me this:

named[17207]: max open files (1024) is smaller than max sockets (4096)

Redhat's BTS [1] tells me this is a kernel issue thatshould be solved [2] 
by the "rlimit: permit setting RLIMIT_NOFILE to RLIM_INFINITY" patch in 
2.6.28.

One of my servers (DNS slave) is running the standard Debian 2.6.26 
kernel, the other (DNS master) is running 2.6.29-rc6 so that does include 
that patch. But both show the error!

I'd appreciate your input where to take this.

Cheers,
FJP

[1] https://bugzilla.redhat.com/show_bug.cgi?id=477540
[2] https://bugzilla.redhat.com/show_bug.cgi?id=461458
