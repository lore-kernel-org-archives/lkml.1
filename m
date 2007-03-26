Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbXCZJO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbXCZJO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 05:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933736AbXCZJO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 05:14:57 -0400
Received: from www.osadl.org ([213.239.205.134]:45413 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753553AbXCZJO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 05:14:56 -0400
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-1?Q?Fr=E9d=E9ric?= RISS <frederic.riss@gmail.com>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       Tino Keitel <tino.keitel@gmx.de>, Bob Moore <robert.moore@intel.com>,
       lenb@kernel.org
In-Reply-To: <1174891519.5550.36.camel@funkylaptop>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070323185022.GQ752@stusta.de>  <1174858456.5550.32.camel@funkylaptop>
	 <1174891519.5550.36.camel@funkylaptop>
Content-Type: text/plain; charset=utf-8
Date: Mon, 26 Mar 2007 11:14:53 +0200
Message-Id: <1174900493.4182.14.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 08:45 +0200, Frédéric RISS wrote:
> Additional data point: I just tried with -rc5 and the issue is still
> present. The config I used for this test defines neither NO_HZ nor
> HIGH_RES_TIMERS.

Do you have CONFIG_HPET_TIMER enabled and does the box have one ?
If yes, can you please turn it off and retry ?

Thanks,

	tglx



