Return-Path: <linux-kernel-owner+w=401wt.eu-S1752184AbYKLKVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbYKLKVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 05:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbYKLKVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 05:21:12 -0500
Received: from mx0.towertech.it ([213.215.222.73]:44632 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751716AbYKLKVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 05:21:12 -0500
Date: Wed, 12 Nov 2008 11:21:06 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>, a.zummo@towertech.it,
       david-b@pacbell.net, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: bunch of drivers: fix 'no irq' case handing
Message-ID: <20081112112106.5b5062f4@i1501.lan.towertech.it>
In-Reply-To: <20081111161728.8a0d73f1.akpm@linux-foundation.org>
References: <20081106174111.GA21882@oksana.dev.rtsoft.ru>
	<20081111161728.8a0d73f1.akpm@linux-foundation.org>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008 16:17:28 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> > rtc-sh.c is using platform_get_irq, but was storing a result into an
> > unsigned type, then was checking for < 0.  This is fixed now.
> > 
> > Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>  
> 
> Do we see any reason why this should be pushed into 2.6.28?

 We are not in hurry I'd say. Also irq is valid on some platforms,
 so the check only makes sense for drivers whose platforms
 do not use it.
-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

