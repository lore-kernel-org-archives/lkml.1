Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472Ab0ASUda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab0ASUda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 15:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911Ab0ASUd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 15:33:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57702 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366Ab0ASUd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 15:33:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Force GFP_NOIO during suspend/resume (was: Re: Memory allocations in .suspend became very unreliable)
Date: Tue, 19 Jan 2010 21:34:11 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       "linux-mm" <linux-mm@kvack.org>, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1263745267.2162.42.camel@barrios-desktop> <201001182206.36365.rjw@sisk.pl> <201001191015.00470.oliver@neukum.org>
In-Reply-To: <201001191015.00470.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001192134.11518.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 January 2010, Oliver Neukum wrote:
> Am Montag, 18. Januar 2010 22:06:36 schrieb Rafael J. Wysocki:
> > I was concerned about another problem, though, which is what happens if the
> > suspend process runs in parallel with a memory allocation that started earlier
> > and happens to do some I/O.  I that case the suspend process doesn't know
> > about the I/O done by the mm subsystem and may disturb it in principle.
> 
> How could this happen? Who would allocate that memory?
> Tasks won't be frozen while they are allocating memory.

The majority of kernel threads are not freezable, but I agree it's rather low
risk.

Rafael
