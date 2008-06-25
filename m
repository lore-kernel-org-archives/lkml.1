Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbYFYI7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbYFYI7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 04:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbYFYI7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 04:59:09 -0400
Received: from mx0.towertech.it ([213.215.222.73]:52816 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751657AbYFYI7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 04:59:08 -0400
Date: Wed, 25 Jun 2008 10:59:06 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: david-b@pacbell.net, lkml <linux-kernel@vger.kernel.org>,
       Mark Lord <lkml@rtr.ca>, akpm@linux-foundation.org
Subject: Re: [rtc-linux] [patch 2.6.26-rc7] rtc_read_alarm() handles
 wraparound
Message-ID: <20080625105906.714e1197@i1501.lan.towertech.it>
In-Reply-To: <200806222042.13929.david-b@pacbell.net>
References: <200806222042.13929.david-b@pacbell.net>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jun 2008 20:42:13 -0700
David Brownell <david-b@pacbell.net> wrote:

> While 0e36a9a4a788e4e92407774df76c545910810d35 made sure that active
> alarms were never returned with invalid "wildcard" fields (negative),
> it can still report (wrongly) that the alarm triggers in the past.
> 
> Example, if it's now 10am, an alarm firing at 5am will be triggered
> TOMORROW not today.  (Which may also be next month or next year...)
> 
> This updates that alarm handling in three ways:
> 
>   * Handle alarm rollover in the common cases of RTCs that don't
>     support matching on all date fields.
> 
>   * Skip the invalid-field logic when it's not needed.
> 
>   * Minor bugfix ... tm_isdst should be ignored, it's one of the
>     fields Linux doesn't maintain.
> 
> A warning is emitted for some of the unhandled rollover cases, but
> the possible combinations are a bit too numerous to handle every
> bit of potential hardware and firmware braindamage.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

