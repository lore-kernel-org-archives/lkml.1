Return-Path: <linux-kernel-owner+w=401wt.eu-S1161135AbXDVXu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161135AbXDVXu6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 19:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161143AbXDVXu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 19:50:58 -0400
Received: from smtpout.mac.com ([17.250.248.184]:61770 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161135AbXDVXu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 19:50:58 -0400
In-Reply-To: <20070422213959.GP5013@traven>
References: <20070422213959.GP5013@traven>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <45C4C5F0-4F09-416D-A237-82FC28DF1883@mac.com>
Cc: chas@cmf.nrl.navy.mil, ecd@atecom.com, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] use spinlock instead of binary mutex in idt77252 driver
Date: Sun, 22 Apr 2007 19:50:36 -0400
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 22, 2007, at 17:39:59, Matthias Kaehlcke wrote:
> use spinlock instead of binary mutex in idt77252 driver

I think you really meant: "Use mutex instead of binary semaphore in  
idt77252 driver", since this is a binary semaphore (not a mutex,  
which are always binary):
> -	struct semaphore	mutex;

and this is a mutex, not a spinlock:
> +	struct mutex		mutex;

Everything else looks good though

Cheers,
Kyle Moffett
