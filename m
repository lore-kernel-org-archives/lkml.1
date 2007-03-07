Return-Path: <linux-kernel-owner+w=401wt.eu-S1422688AbXCGJjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422688AbXCGJjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422686AbXCGJjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:39:53 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:57391 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422681AbXCGJjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:39:51 -0500
Message-ID: <45EE8829.4060304@bull.net>
Date: Wed, 07 Mar 2007 10:38:49 +0100
From: Pierre Peiffer <pierre.peiffer@bull.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       =?ISO-8859-15?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
Subject: How to distinguish original kernel vs -rt kernel
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 07/03/2007 10:41:34,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 07/03/2007 10:41:35,
	Serialize complete at 07/03/2007 10:41:35
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Supposing I have an external kernel module which I would like to compile against 
both original kernel and -rt kernel, what is the proper/most elegant way to know 
which kernel I'm compiling with ?
I've only found the EXTRAVERSION define, am I missing a better way ?

In fact, I'm facing the problem of HRTIMER_ABS/REL being renamed to 
HRTIMER_MODE_ABS/REL with patch -rt. Is there a reason of this ?

Does anyone have an objection of keeping it the same (let's say 
HRTIMER_ABS/REL) in kernel -rt ?

Thanks,

-- 
Pierre
