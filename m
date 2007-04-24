Return-Path: <linux-kernel-owner+w=401wt.eu-S1161758AbXDXNWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161758AbXDXNWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 09:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161760AbXDXNWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 09:22:08 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:60778 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161758AbXDXNWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 09:22:07 -0400
Date: Tue, 24 Apr 2007 15:21:44 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Stephan von Krawczynski <skraw@ithnet.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: How to walk through the tasklist ?
In-Reply-To: <20070424145827.467595a6.skraw@ithnet.com>
Message-ID: <Pine.LNX.4.61.0704241521330.2490@yvahk01.tjqt.qr>
References: <20070424145827.467595a6.skraw@ithnet.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 24 2007 14:58, Stephan von Krawczynski wrote:
>Hello all,
>
>can anyone give me a short hint how walking through the tasklist in a device
>driver can be achieved nowadays. In ancient pre-20 times you could simply:
>
>    read_lock(&tasklist_lock);
>    p=current; 
>    do {
>        if (p->pid==pid) {  
>            read_unlock(&tasklist_lock);
>            /* found */
>        }
>        p=p->next_task;
>    } while (p!=current);
>    read_unlock(&tasklist_lock);
>
>But since tasklist_lock is gone this is not safe any longer. So, what can I do?


How about for_each_process?


Jan
-- 
