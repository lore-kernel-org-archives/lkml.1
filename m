Return-Path: <linux-kernel-owner+w=401wt.eu-S1752531AbXLBWQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbXLBWQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 17:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbXLBWQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 17:16:19 -0500
Received: from mx0.towertech.it ([213.215.222.73]:49706 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751132AbXLBWQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 17:16:19 -0500
Date: Sun, 2 Dec 2007 23:13:22 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alessandro Zummo <a.zummo@towertech.it>,
       David Brownell <david-b@pacbell.net>,
       Nickk Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND] [PATCH] RTC: assure proper memory ordering with
 respect to RTC_DEV_BUSY flag (was Re: RTC: convert mutex to bitfield)
Message-ID: <20071202231322.2c104d8c@i1501.lan.towertech.it>
In-Reply-To: <Pine.LNX.4.64.0712022258120.13260@jikos.suse.cz>
References: <200711301355.03139.nickpiggin@yahoo.com.au>
	<Pine.LNX.4.64.0711300944020.12807@jikos.suse.cz>
	<Pine.LNX.4.64.0712022258120.13260@jikos.suse.cz>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Dec 2007 23:00:04 +0100 (CET)
Jiri Kosina <jkosina@suse.cz> wrote:

> [ nobody seems to have picked this up, resending. This is a fix for 
>   commit 8853c202b4 in Linus' tree ]
> 
> From: Jiri Kosina <jkosina@suse.cz>
> 
> RTC: assure proper memory ordering with respect to RTC_DEV_BUSY flag
> 
> We must make sure that the RTC_DEV_BUSY flag has proper lock semantics, 
> i.e. that the RTC_DEV_BUSY stores clearing the flag don't get reordered 
> before the preceeding stores and loads and vice versa.
> 
> Spotted by Nick Piggin.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

 missed it, sorry.

 
 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

