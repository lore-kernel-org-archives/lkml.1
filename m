Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbZIUAmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbZIUAmV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 20:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbZIUAmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 20:42:19 -0400
Received: from p3plsmtpa01-07.prod.phx3.secureserver.net ([72.167.82.87]:34980
	"HELO p3plsmtpa01-07.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751534AbZIUAmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 20:42:19 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Sep 2009 20:42:19 EDT
Date: Mon, 21 Sep 2009 00:35:02 +1200
From: Kelly Bowa <kbpm@tuxedu.org>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Eric Paris <eparis@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: BUG: scheduling while atomic: ..
Message-ID: <20090920123502.GA4566@tuxedu.home>
Mail-Followup-To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
	Eric Paris <eparis@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jens Axboe <jens.axboe@oracle.com>
References: <20090920115423.GA28749@tuxedu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090920115423.GA28749@tuxedu.home>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kelly Bowa (kbpm@tuxedu.org) wrote:
> hi,
> found following bug in 2.6.31-rc8. CPU model is Intel(R) Atom(TM) CPU N270. 
> This is produced at boot time. I havent had time to look into this yet but 
> looks like an ACPI bug to me..
> 
also in dmesg i find:
kmemleak: 9 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

kbpm
