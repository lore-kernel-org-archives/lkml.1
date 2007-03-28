Return-Path: <linux-kernel-owner+w=401wt.eu-S1753102AbXC1VUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbXC1VUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 17:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbXC1VUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 17:20:09 -0400
Received: from smtp.osdl.org ([65.172.181.24]:59926 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbXC1VUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 17:20:07 -0400
Date: Wed, 28 Mar 2007 14:20:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Andy Grover" <andrew.grover@intel.com>,
       "Paul Diefenbaugh" <paul.s.diefenbaugh@intel.com>, len.brown@intel.com,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm2 -- ACPI problems (lid switch broken, always
 shows running from AC, plugging in AC hangs machine)
Message-Id: <20070328142000.ebc7712d.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0703281355h13f1bd70s9eb94092bfa9c3e@mail.gmail.com>
References: <a44ae5cd0703281355h13f1bd70s9eb94092bfa9c3e@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007 13:55:54 -0700
"Miles Lane" <miles.lane@gmail.com> wrote:

> My laptop (HP dv1240us) is always showing that my laptop is plugged
> into AC power, even when it is running off of the battery.  When I
> plug into the AC after running on the battery, the machine immediately
> locks up.  Also, the laptop lid button isn't working -- pressing it
> doesn't trigger a suspend.

OK, thanks.

If you have time, could you please test

2.6.21-rc5 +
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm2/broken-out/origin.patch +
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm2/broken-out/git-acpi.patch

which will allow us to eliminate any non-acpi patches.

And please keep an eye on these bugs for us, don't let us merge these
problems into 2.6.22.  It is bad of us to allow known failures to propagate
into mainline and it has happened a couple of times in recent months.

