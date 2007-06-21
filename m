Return-Path: <linux-kernel-owner+w=401wt.eu-S1757602AbXFUTAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602AbXFUTAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbXFUTAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:00:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:60568 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbXFUTAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:00:32 -0400
From: Jan Kandziora <jjj@gmx.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Limiting load of certain processes
Date: Thu, 21 Jun 2007 21:00:28 +0200
User-Agent: KMail/1.9.5
References: <200706211950.40825.jjj@gmx.de> <Pine.LNX.4.64.0706212020520.26568@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0706212020520.26568@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706212100.28381.jjj@gmx.de>
X-Provags-ID: V01U2FsdGVkX1+Sb0yjjFUFnjlqh2EX32Wv5H3XZloS6c83Toq
 Ui9xaS0X3jgNeyF7BQzLXSckcgg5g2L7E5SC3QpsAQXlIDz4WF
 yXfH0NXbP8OReFmLd/d9Q==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 21. Juni 2007 20:26 schrieb Jan Engelhardt:
>
> Of course there may be hacks that try to figure out if a DOS window is
> idle, waiting for user input. (Seems like a new invention in Windows 2000
> and up). Since dosemu and all the emulators are not running a genuine
> Microsoft DOS / have source, it should be easy game for them to wait
> non-busily.
>
Well, the "tamedos" shareware does it that way. It works fairly well, but not 
too well. DOSEMU doesn't address this problem besides from the suspending 
whenever the dosemu window is iconified.

My idea was *not* to schedule a process for running, even if it is the only 
runnable one, if it is marked as a "presumably bad mannered" process and 
consumed its previous timeslice to the whole. Instead an idle slice is done. 
After a configureable amount of time, the bad mannered process is allowed to 
run again.

I know it's a crude idea for everyday Linux processes, but for dosemu driven 
applications, which behave badly in a multitasking OS *and* for which source 
code isn't available, it may be worth to discuss.

Kind regards

	Jan

