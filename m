Return-Path: <linux-kernel-owner+w=401wt.eu-S1753091AbXDWGwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbXDWGwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 02:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbXDWGwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 02:52:18 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:44390
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753091AbXDWGwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 02:52:17 -0400
Date: Mon, 23 Apr 2007 08:55:20 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: chas@cmf.nrl.navy.mil, ecd@atecom.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use spinlock instead of binary mutex in idt77252 driver
Message-ID: <20070423065520.GR5013@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Kyle Moffett <mrmacman_g4@mac.com>, chas@cmf.nrl.navy.mil,
	ecd@atecom.com, linux-kernel@vger.kernel.org
References: <20070422213959.GP5013@traven> <45C4C5F0-4F09-416D-A237-82FC28DF1883@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C4C5F0-4F09-416D-A237-82FC28DF1883@mac.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Sun, Apr 22, 2007 at 07:50:36PM -0400 Kyle Moffett ha dit:

> On Apr 22, 2007, at 17:39:59, Matthias Kaehlcke wrote:
> >use spinlock instead of binary mutex in idt77252 driver
> 
> I think you really meant: "Use mutex instead of binary semaphore in  
> idt77252 driver", since this is a binary semaphore (not a mutex,  
> which are always binary):
> >-	struct semaphore	mutex;
> 
> and this is a mutex, not a spinlock:
> >+	struct mutex		mutex;
> 
> Everything else looks good though

you're totally right. like in another patch i sent at the same time i
messed up the description. as you point out it should read "Use mutex
instead of binary semaphore in idt77252 driver". in the last days i
reported some spinlock related bugs, i suppose that made me write
spinlock instead of mutex ...

thanks for your comments

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

                If you don't know where you are going,
               you will probably end up somewhere else
                         (Laurence J. Peter)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
