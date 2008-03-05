Return-Path: <linux-kernel-owner+w=401wt.eu-S1752012AbYCEN0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbYCEN0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 08:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbYCEN03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 08:26:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47777 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbYCEN02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 08:26:28 -0500
Date: Wed, 5 Mar 2008 14:25:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Zhang, Rui" <rui.zhang@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, kay.sievers@vrfy.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Alexey Dobriyan <adobriyan@sw.ru>,
       dm-devel@redhat.com
Subject: Re: 2.6.25-rc regression: kernel panic on boot
Message-ID: <20080305132537.GC11701@elte.hu>
References: <1204500349.10256.171.camel@acpi-hp-zz.sh.intel.com> <20080303224259.GA27008@suse.de> <20080304135447.GD32383@elte.hu> <20080304104312.457ba3a8.akpm@linux-foundation.org> <20080304193348.GC5534@suse.de> <alpine.LFD.1.00.0803041200390.12253@woody.linux-foundation.org> <20080304202436.GA29456@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304202436.GA29456@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg KH <gregkh@suse.de> wrote:

> It's as if we should just change the config option name every kernel 
> release to make sure that users keep things up to date.  So Ingo's 
> original proposal makes sense to me, more so than this patch.

this change is now upstream and included in -rc4:

  ------------------->
  commit d47846c5866b7d98a1173c86a39d810a06647329
  Author: Ingo Molnar <mingo@elte.hu>
  Date:   Tue Mar 4 14:54:47 2008 +0100

      sysfs: CONFIG_SYSFS_DEPRECATED fix
  <------------------

thanks Greg!

	Ingo
