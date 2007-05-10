Return-Path: <linux-kernel-owner+w=401wt.eu-S1759518AbXEKM3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518AbXEKM3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 08:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbXEKM25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 08:28:57 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1346 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755845AbXEKM24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 08:28:56 -0400
Date: Thu, 10 May 2007 11:36:24 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Albert Cahalan <acahalan@gmail.com>
Cc: johnstul@us.ibm.com, tjanouse@redhat.com, linux-kernel@vger.kernel.org,
       tsmetana@redhat.com, riel@redhat.com
Subject: Re: Broken process startup times after suspend (regression)
Message-ID: <20070510113623.GB4052@ucw.cz>
References: <787b0d920705052016o2d7e36ffsdc80302228b0ee1e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <787b0d920705052016o2d7e36ffsdc80302228b0ee1e@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >Indeed. The monotonic clock's behavior around suspend 
> >and resume
> >is poorly defined. When we increased it, folks didn't 
> >like the
> >fact that uptime would increase while a system was 
> >suspended.
> 
> The uptime really does need to increase during suspend. 
> Otherwise,
> things get really weird with devices like the OLPC XO 
> which will be
> sleeping between keystrokes. You could run the device 
> for hours,
> yet get an uptime of only a few minutes. Suspended time 
> should get
> counted as stolen time, same as when a hypervisor takes 
> away time.

Yes, please. Just revert the offending patches, we don't want another
/proc/stat field.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
