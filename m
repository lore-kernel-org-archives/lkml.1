Return-Path: <linux-kernel-owner+w=401wt.eu-S932953AbXGYBj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbXGYBj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 21:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760644AbXGYBjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 21:39:49 -0400
Received: from mx0.towertech.it ([213.215.222.73]:37517 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760497AbXGYBjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 21:39:48 -0400
Date: Wed, 25 Jul 2007 03:37:35 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: david-b@pacbell.net, Adrian Bunk <bunk@stusta.de>,
       Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [rtc-linux] Re: rtc-ds1307.c: array overrun
Message-ID: <20070725033735.428d2630@i1501.lan.towertech.it>
In-Reply-To: <200707221817.18338.david-b@pacbell.net>
References: <20070723004422.GR26212@stusta.de>
	<200707221817.18338.david-b@pacbell.net>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jul 2007 18:17:17 -0700
David Brownell <david-b@pacbell.net> wrote:

> 
> On Sunday 22 July 2007, Adrian Bunk wrote:
> > The Coverity checker spotted the following array overrun
> > in drivers/rtc/rtc-ds1307.c:
> 
> Typo -- thanks, fix is attached.
> 
> ========	CUT HERE
> Fix a typo turned up by a Coverity check:  referring to the wrong register,
> which could cause problems restarting DS1338 RTCs after their oscillator
> halted.  (For example, if the backup battery died.)
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

 
 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

