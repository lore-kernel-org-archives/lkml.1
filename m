Return-Path: <linux-kernel-owner+w=401wt.eu-S1752955AbZKZVkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbZKZVkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 16:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbZKZVkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 16:40:52 -0500
Received: from elettra.colt-to.towertech.it ([213.215.222.70]:50314 "EHLO
	elettra.colt-to.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752887AbZKZVkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 16:40:51 -0500
Date: Thu, 26 Nov 2009 22:40:54 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: Johannes Weiner <jw@emlix.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Paul Gortmaker <p_gortmaker@yahoo.com>, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] rtc-x1205: fix rtc_time to y2k register value
 conversion
Message-ID: <20091126224054.7f2dfe21@linux.lan.towertech.it>
In-Reply-To: <20091126010234.GA31257@emlix.com>
References: <1259166736-31006-1-git-send-email-jw@emlix.com>
	<20091125141100.d9348bd5.akpm@linux-foundation.org>
	<20091126010234.GA31257@emlix.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Nov 2009 02:02:34 +0100
Johannes Weiner <jw@emlix.com> wrote:

> eah, I think so too, although I hope we can get feedback from the
> authors beforehand.
> 
> Because #1 looks obvious to me and makes the driver at all usable for
> me but the code has been like that since the initial merge in 2006.
> So either
> 
> 	a) nobody ever set the date with this thing,
> 	b) every embedded linux company has its own private patch or
> 	c) I am missing something,
> 
> where likelyhood is in reverse order.  That makes me feel slightly
> uncomfortable.

 The last time I used an x1205 it worked nicely. It's been two or three
 years since. However the datasheet says 0x19 o 0x20 so your patch
 looks good.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

