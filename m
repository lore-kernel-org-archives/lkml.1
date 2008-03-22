Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbYCVPRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbYCVPRY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 11:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbYCVPRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 11:17:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:35627 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbYCVPRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 11:17:16 -0400
Date: Sat, 22 Mar 2008 16:17:14 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: rjw@sisk.pl, linux-main <linux-kernel@vger.kernel.org>
Subject: Re: Proper way to invoke suspend?
Message-ID: <20080322151714.GA21194@atrey.karlin.mff.cuni.cz>
References: <20080321203040.99655491.Kristoffer.Ericson@Gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321203040.99655491.Kristoffer.Ericson@Gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Been looking around for examples, but obviously something I don't understand. 
> Currently I set apm_queue_event(APM_USER_SUSPEND) inside the power button interrupt, this does nothing.
> 
> However if I cat the state, it goes into suspend. Resume fails but thats another question.

I'd prefer not using apm_queue_event in new code... There are some
routines in kernel/power/main.c you should be calling...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
