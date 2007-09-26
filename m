Return-Path: <linux-kernel-owner+w=401wt.eu-S1762596AbXIZWX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762596AbXIZWX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 18:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759006AbXIZWXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 18:23:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56632 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758498AbXIZWXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 18:23:48 -0400
Date: Wed, 26 Sep 2007 15:22:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [REGRESSION from 2.6.23-rc8] (was: Re: 2.6.23-rc4-mm1 and
 -rc6-mm1: boot failure on HP nx6325, related to clockevents)
In-Reply-To: <1190842476.23376.57.camel@chaos>
Message-ID: <alpine.LFD.0.999.0709261521440.3579@woody.linux-foundation.org>
References: <200709231257.12213.rjw@sisk.pl>  <1190832665.23376.38.camel@chaos>
 <200709262149.54732.rjw@sisk.pl>  <200709262300.28336.rjw@sisk.pl>
 <1190842476.23376.57.camel@chaos>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 26 Sep 2007, Thomas Gleixner wrote:
> > 
> > 1) current Linus' tree doesn't boot with any command line (regression)
> > 
> > [  Linus, please revert commit e66485d747505e9d960b864fc6c37f8b2afafaf0

Reverted.

> OK, this explains 2) and 3). I just looked into the code and the logic
> vs. noapictimer on SMP is completely broken.

..and thanks for the explanation.

Thanks for finding it so quickly guys. Sounds like this will be fixed 
properly in 2.6.24 with the x86 merge (which hopefully brings in the hrt 
patch too)

		Linus
