Return-Path: <linux-kernel-owner+w=401wt.eu-S1761780AbYF0MVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761780AbYF0MVB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759953AbYF0MLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:11:24 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2925 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761475AbYF0MLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:11:16 -0400
Date: Thu, 26 Jun 2008 22:12:17 +0200
From: Pavel Machek <pavel@suse.cz>
To: Mayank Sharma <mayanks@sirf.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Time drifting after multiple sleep/wakeup in timekeeping
Message-ID: <20080626201216.GD9878@ucw.cz>
References: <013B1C915F9462459242424413ABB264011AC64C@bnglmail.sirf.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <013B1C915F9462459242424413ABB264011AC64C@bnglmail.sirf.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-06-25 17:18:52, Mayank Sharma wrote:
> Hi,
> 
> I noticed a bug with respect to time drifting after multiple sleep/wakeup sequence. We have an embedded ARM11 based platform on which we have successfuly ported Linux. We also have a RTC on board. Hence we have implemented the read_persistent_clock() function overriding the one defined in kernel/time/timekeeping.c. What we observed was that after doing multiple sleep/wakeup sequences, the time reported by RTC and gettimeofday was drifting. After about 10 iterations the gettimeofday was lagging by about one second. Subsequently the lag only increased. 
> 

Hmm, should I look forward for linux-based gps?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
