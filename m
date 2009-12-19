Return-Path: <linux-kernel-owner+w=401wt.eu-S1751909AbZLSNz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbZLSNz6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 08:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbZLSNz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 08:55:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37868 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbZLSNz4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 08:55:56 -0500
From: Jean Delvare <jdelvare@suse.de>
Organization: SuSE Linux
To: minyard@acm.org
Subject: Re: [PATCH] IPMI: Add parameter to limit CPU usage in kipmid
Date: Sat, 19 Dec 2009 14:56:04 +0100
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Martin Wilck <martin.wilck@ts.fujitsu.com>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
References: <20091216212354.GA13097@minyard.local> <200912172107.45393.jdelvare@suse.de> <20091217220821.GA4513@minyard.local>
In-Reply-To: <20091217220821.GA4513@minyard.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200912191456.04950.jdelvare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 17 décembre 2009 23:08, Corey Minyard a écrit :
> I cleaned up the patch some.  I added some state results to the list of
> things to be busy waited for (should improve performance a bit) and
> changed the schedule_timeout_interruptible back to 1, since that's
> what it's supposed to be.  And I added some comments.

Thanks for doing this!

> I did some testing on my system here.  On my system, kipmid uses almost
> no CPU normally.  If I set the kipmid_max_busy_us value to 500, the
> interface was more than 5 times slower.  I had to set the value up to
> 35000 for it to go back to the normal performance, and it was pretty
> linear between the two values.  So this is definiately not for all
> systems.
> 
> Can you try this out to make sure its ok?

I don't have any hardware where I can test this myself. But hopefully
Martin does?

Thanks,
-- 
Jean Delvare
Suse L3
