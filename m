Return-Path: <linux-kernel-owner+w=401wt.eu-S1757017AbYFWI2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017AbYFWI2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 04:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbYFWI20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 04:28:26 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:48188 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbYFWI2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 04:28:25 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: /proc 2.6.24 changes for guest CPU accounting
Date: Mon, 23 Jun 2008 10:28:13 +0200
User-Agent: KMail/1.9.9
Cc: Laurent Vivier <Laurent.Vivier@bull.net>,
       Samuel Thibault <samuel.thibault@ens-lyon.org>, ap@zip.com.au,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <485DFFB4.3080008@gmail.com>
In-Reply-To: <485DFFB4.3080008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806231028.13965.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 22. Juni 2008 schrieb Michael Kerrisk:
> Hi Laurent,
> 
> A note and patch from Samuel alerted me to your commits
> 9ac52315d4cf5f561f36dabaf0720c00d3553162 and
> 5e84cfde51cf303d368fcb48f22059f37b3872de, which in 2.6.24 changed /proc/stat
> and /proc/PID/stat.  Would you please CC me on kernel-userspace interface
> changes, so that they have a chance of getting documented in man-pages.
[...]
> +.TP
> +\fIguest_time\fP %lu (since Linux 2.6.24)
> +Guest time of the process (time spent running a virtual CPU
> +for a guest operating system), in centiseconds.
> +.TP
> +\fIcguest_time\fP %ld (since Linux 2.6.24)
> +Guest time of the process's children, in centiseconds.
[...]
> +
> +Since Linux 2.6.24, there is a ninth column,
> +.IR guest ,
> +which is the time spent running a virtual CPU for guest
> +operating systems under teh control of the Linux kernel.
> +.\" See Changelog entry for 5e84cfde51cf303d368fcb48f22059f37b3872de

Maybe you should mention that guest time is accounted twice: user and guest. 
So if guest time aware userspace wants to to calcuate user time without 
guests time, it should subtract the guest time from user.

Christian
