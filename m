Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbXIVIu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbXIVIu5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 04:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbXIVIuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 04:50:50 -0400
Received: from www.osadl.org ([213.239.205.134]:40223 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751089AbXIVIuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 04:50:50 -0400
Subject: Re: clockevents: fix resume logic
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <20070917183737.GB5966@ucw.cz>
References: <200707220159.l6M1xBgH001236@hera.kernel.org>
	 <200709111323.56030.rjw@sisk.pl>
	 <20070911042228.1ef690e0.akpm@linux-foundation.org>
	 <200709111409.13796.rjw@sisk.pl>
	 <20070911112531.80bac380.akpm@linux-foundation.org>
	 <1189535883.5235.13.camel@chaos>
	 <20070911114417.3f6e9e1b.akpm@linux-foundation.org>
	 <1189540321.5235.21.camel@chaos>
	 <20070912021248.0c653525.akpm@linux-foundation.org>
	 <20070917183737.GB5966@ucw.cz>
Content-Type: text/plain
Date: Sat, 22 Sep 2007 10:50:47 +0200
Message-Id: <1190451047.4035.29.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-17 at 18:37 +0000, Pavel Machek wrote:
> > That's a bit tricky because hitting the keyboard is what unsticks things. 
> > And the video is black after resume-from-RAM (has always been thus) and we
> 
> Ok, can we try to fix the video issue for you? That should make the
> development easier... I assume you tried s2ram from suspend.sf.net,
> and no combination of switches helped?

I have the same issue. Blank screen after suspend to ram. Hibernate
works.

Do you have a debug patch or something ?

	tglx


