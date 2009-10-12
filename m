Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbZJLBsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbZJLBsF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 21:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbZJLBsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 21:48:03 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:56214 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbZJLBsC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 21:48:02 -0400
MIME-Version: 1.0
In-Reply-To: <L6tb-VyKHZK.A.lrB.Rzl0KB@chimera>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
	 <L6tb-VyKHZK.A.lrB.Rzl0KB@chimera>
Date: Sun, 11 Oct 2009 18:47:26 -0700
Message-ID: <f488382f0910111847y365ad85fj89fc8c65d510052b@mail.gmail.com>
Subject: Re: [Bug #14377] "conservative" cpufreq governor broken
From: Steven Noonan <steven@uplinklabs.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eero Nurkkala <ext-eero.nurkkala@nokia.com>,
       Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

There's a commit to fix this in the stable queue for 2.6.31.x and said
fix is already in the 2.6.32 tree. The commit is titled "NOHZ: update
idle state also when NOHZ is inactive" (fdc6f192e7).

- Steven

On Sun, Oct 11, 2009 at 4:01 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14377
> Subject         : "conservative" cpufreq governor broken
> Submitter       : Steven Noonan <steven@uplinklabs.net>
> Date            : 2009-10-05 16:32 (7 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f2e21c9610991e95621a81407cdbab881226419b
> References      : http://marc.info/?l=linux-kernel&m=125476067108252&w=4
>
>
>
