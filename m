Return-Path: <linux-kernel-owner+w=401wt.eu-S1161291AbXDWHhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161291AbXDWHhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 03:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965685AbXDWHhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 03:37:39 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:52628
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S965668AbXDWHhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 03:37:24 -0400
Date: Mon, 23 Apr 2007 09:40:26 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: "Eddie C. Dost" <ecd@atecom.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, chas@cmf.nrl.navy.mil,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use spinlock instead of binary mutex in idt77252 driver
Message-ID: <20070423074026.GC10339@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	"Eddie C. Dost" <ecd@atecom.com>,
	Kyle Moffett <mrmacman_g4@mac.com>, chas@cmf.nrl.navy.mil,
	linux-kernel@vger.kernel.org
References: <20070422213959.GP5013@traven> <45C4C5F0-4F09-416D-A237-82FC28DF1883@mac.com> <20070423065520.GR5013@traven> <20070423071608.GA15338@gannet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423071608.GA15338@gannet>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Mon, Apr 23, 2007 at 09:16:08AM +0200 Eddie C. Dost ha dit:
 
> Please note that the semaphore is used to lock the idt77252 config
> tables among multiple users including atmsigd even on single processor
> machines. Does this work with mutexes?

afaik mutexes have the same behaviour as binary semaphores that are
used as mutexes (always locked and unlocked by the same
process/thread):

".. the semaphore type can officially be considered to be on its way
out. New code should not use semaphores, and old code which uses
semaphores as mutexes should be converted over when an opportunity
presents itself."

http://lwn.net/Articles/167034/

please correct me if i'm wrong, i'm just doing my first steps with
linux kernel development

regards

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

    C treats you like a consenting adult. Pascal treats you like a
          naughty child. Ada treats you like a criminal
                      (Bruce Powel Douglass)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
