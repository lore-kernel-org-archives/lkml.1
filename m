Return-Path: <linux-kernel-owner+w=401wt.eu-S1752443AbYGTUgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbYGTUgn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 16:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbYGTUgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 16:36:33 -0400
Received: from mx0.towertech.it ([213.215.222.73]:53150 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752334AbYGTUgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 16:36:32 -0400
Date: Sun, 20 Jul 2008 22:36:29 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Ben Dooks <ben-linux@fluff.org>
Cc: a.zummo@towertech.it, linux-kernel@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>, akpm@linux-foundation.org
Subject: Re: RTC: rtc-s3c: update IRQ handling
Message-ID: <20080720223629.7933db23@i1501.lan.towertech.it>
In-Reply-To: <20080720155031.013012457@fluff.org.uk>
References: <20080720155031.013012457@fluff.org.uk>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jul 2008 16:50:31 +0100
Ben Dooks <ben-linux@fluff.org> wrote:

> The rtc-s3c.c driver has been using it's own ioctl() handling
> to deal with alarm and periodic interrupts to handle what
> should now be done with the rtc core code.
> 
> Change to using the .irq_set_freq and .irq_set_state driver
> entries and remove the .ioctl handling.
> 
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>

 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

