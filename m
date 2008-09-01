Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbYIAG0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbYIAG0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 02:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbYIAG0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 02:26:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4480 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753758AbYIAG0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 02:26:13 -0400
Date: Mon, 1 Sep 2008 08:25:13 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Leisner, Martin" <Martin.Leisner@xerox.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: FW: [linux-pm] select with timeout across S3
Message-ID: <20080901062513.GA9851@ucw.cz>
References: <556445368AFA1C438794ABDA8901891C09639B7A@USA0300MS03.na.xerox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <556445368AFA1C438794ABDA8901891C09639B7A@USA0300MS03.na.xerox.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The behavior of linux (in both 2.4.x and 2.6.x) is when the processor
> sleeps, timeouts on select don't take into account the sleep time,
> only the run time.
> 
> For example, this program should pause for 10 minutes -- however
> if we go into S3 in the middle its pausing for (10 minutes + time in
> S3)
> 
> I saw this on both 2.6.20 and 2.6.22...

Can you test this on 2.6.27-rc? We did have some fixes in that
area....

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
