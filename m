Return-Path: <linux-kernel-owner+w=401wt.eu-S1423083AbXBUUTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423083AbXBUUTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 15:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423077AbXBUUTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 15:19:36 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42034 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423083AbXBUUTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 15:19:35 -0500
Date: Wed, 21 Feb 2007 12:18:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Daniel Walker <dwalker@mvista.com>
cc: tglx@linutronix.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu
Subject: Re: Linux 2.6.21-rc1
In-Reply-To: <1172088050.8577.71.camel@imap.mvista.com>
Message-ID: <Pine.LNX.4.64.0702211216560.4043@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> 
 <1172075053.8577.38.camel@imap.mvista.com>  <1172077664.25076.75.camel@localhost.localdomain>
  <1172078340.8577.43.camel@imap.mvista.com>  <1172079671.25076.80.camel@localhost.localdomain>
  <1172079523.8577.48.camel@imap.mvista.com>  <1172081931.25076.95.camel@localhost.localdomain>
  <1172082200.8577.56.camel@imap.mvista.com>  <1172085792.25076.119.camel@localhost.localdomain>
 <1172088050.8577.71.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 21 Feb 2007, Daniel Walker wrote:
> 
> There's a compile failure during my bisect.

When that happens, you need to pick another commit to try than the one git 
selected for you automatically. You can do that by doing

	git bisect visualize

and select another commit somewhere fairly close to a mid-point, and try 
that with

	git reset --hard <commit-sha1>

instead.

		Linus
