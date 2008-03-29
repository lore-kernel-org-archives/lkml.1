Return-Path: <linux-kernel-owner+w=401wt.eu-S1756984AbYC2WR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984AbYC2WR2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 18:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbYC2WRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 18:17:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60464 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbYC2WRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 18:17:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Richard Jonsson <richie@coderworld.net>
Subject: Re: Keyboard weirdness: keys get stuck
Date: Sat, 29 Mar 2008 22:46:57 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <47EEA097.5000701@coderworld.net>
In-Reply-To: <47EEA097.5000701@coderworld.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803292246.58524.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 29 of March 2008, Richard Jonsson wrote:
> With 2.6.25-rc6-git-something I have experienced stuck keys. When typing 
> a  sentence a character repeats aboooooooout 10 times, or as 'about' 
> above ;). I tested with a new kernel today, 2.6.25-rc7-git-something and 
> the problem is still present.
> 
> With 2.6.25-rc3 the keyboard is fine, and I've not tried with any kernel 
> in between.
> 
> As a side note, timestamps gets mixed up in dmesg output in a 1-2 second 
> span. Maybe related?
> 
> This is on a HP dv2140eu laptop, x86_64 SMP. Please cc me if you want 
> configuration details or testing to be done.

This doesn't sound good at all.

Ingo, Thomas, are there any obvious candidates in the x86 and/or scheduler area
that might cause it to happen?

Rafael
