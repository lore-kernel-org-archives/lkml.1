Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbZFPOmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbZFPOmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 10:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755480AbZFPOmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 10:42:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:41975 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975AbZFPOmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 10:42:23 -0400
Date: Tue, 16 Jun 2009 07:43:04 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Robert Bradbury <robert.bradbury@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Scheduler fails to allow for "niceness" with new/fast processes
Message-ID: <20090616074304.4e41ae98@infradead.org>
In-Reply-To: <deaa866a0906160723k78c3c54bv35e2e2406e3d13d1@mail.gmail.com>
References: <deaa866a0906160723k78c3c54bv35e2e2406e3d13d1@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009 10:23:59 -0400
Robert Bradbury <robert.bradbury@gmail.com> wrote:

> I primarily use my system (Gentoo) for 3 tasks: (a) Browsing the web
> related to biomedical research (I may often have dozens of windows and
> hundreds of tabs open in several browsers); (b) Running fairly CPU &
> Disk I/O intensive genetics programs; (c) Performing low priority
> rebuilds of various packages (Gentoo packages, firefox/chrome
> releases, etc.
> 
> Now (a) is my top priority -- I want my active browser to get all of
> the CPU if it requires it (fast window/tab opens, quick page reloads &
> redraws, etc.);  (b) is of lesser priority and (c) is lowest priority.
>  This is on a 2.8 GHz Pentium IV (Prescott) with 3GB of RAM and 12GB
> of swap on two drives.
> 
> Now I normally run (c) processes at nice -n 19 to (in theory) get the
> least CPU allocation.  But it would appear that this does not work.  I
> often experience extremely poor user (esp. browser) performance when
> running package builds.  In monitoring the package builds I find that


have you tried running latencytop in this workload to see why you're
really stalling? Latencytop can at least tell you for sure if it's
a scheduler issue or something else...

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
