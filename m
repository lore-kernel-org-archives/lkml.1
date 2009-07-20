Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbZGTVgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbZGTVgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 17:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbZGTVgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 17:36:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49098 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752255AbZGTVgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 17:36:37 -0400
Date: Mon, 20 Jul 2009 14:35:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       wolput@onsneteindhoven.nl,
       Nico Schottelius <nico-linux-20090706@schottelius.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       dri-devel@lists.sourceforge.net
Subject: Re: [Bug #13554] linux-image-2.6.30-1-686, KMS enabled: black
 screen, no X window
Message-Id: <20090720143549.b0aee3a9.akpm@linux-foundation.org>
In-Reply-To: <bXZeuxPQAWE.A.lOH.aApUKB@chimera>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
	<bXZeuxPQAWE.A.lOH.aApUKB@chimera>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  7 Jul 2009 02:00:46 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13554
> Subject		: linux-image-2.6.30-1-686, KMS enabled: black screen, no X window
> Submitter	: Jos van Wolput <wolput@onsneteindhoven.nl>
> Date		: 2009-06-17 06:28 (20 days old)

Nico reported a black-screen regression too.  Subject:

	2.6.31-r2: Xorg: Black screen


  Compared to the other normal brightness problems, with 2.6.31-r2
  xorg starts, but there is no image displayed (neither on internal nor
  external monitor).

  Switching back to console does not change the status, though
  hitting ctrlaltdel reboots the system (i.e.  still up and running
  fine).

  It works with 2.6.30-rc7 (besides sometimes the brightness is
  broken there).


This looks like it might be a post-2.6.30 regression, in which case it
might have a separate cause.


We're having a lot of problems in this area.
