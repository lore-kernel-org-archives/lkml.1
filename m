Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbYLGM4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbYLGM4X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 07:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbYLGM4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 07:56:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:62582 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbYLGM4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 07:56:12 -0500
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: linux-kernel@vger.kernel.org
Subject: Re: 3ware 9650SE-16ML w/XFS & RAID6: first impressions
Date: Sun, 7 Dec 2008 13:55:48 +0100
User-Agent: KMail/1.9.9
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org,
       xfs@oss.sgi.com
References: <alpine.DEB.1.10.0812030930450.22299@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0812030930450.22299@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812071355.49427.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX18r+fhMar7UFdIilVaYHjyS+x8ofzfb0hotqN3
 vaDiWCWP9pMGdRrnmSzmxpKl7GQKijG2QviZ4bcdimZXkytJNa
 Yzga3A214k9ksRtTJOHwQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 3. Dezember 2008 schrieb Justin Piszcz:
> For read speed, it appears that there is some overhead (2x). With
> software raid6 I used to get 1.0Gbyte/sec read speed, or at least
> 800MiB/s across the entire array, now I only get 538MiB/s across the
> entire array. However, write speed is improved. Before it was in the mid
> 400s for RAID6 and peaking at 502MiB/s at the outer edge of the drives.
> For the write speed now, its around 620-640MiB/s at the end of the array
> and 580-620MiB/s going in further and 502MiB/s across the entire array. I
> always heard all of the horror stories with 3ware cards, it turns out
> they're not so bad after all.

Hustin, if you're after speed, AND sane support, you may consider trying 
Areca products. I'm biased, since 3ware fed me up completely, when it came 
to a single drive failure in a RAID 5 setup: the support only provides an 
ugly web interface: when posting my problem, they replied with:

>>>
Thank you for contacting 3ware Technical Support.
Your submission has been received and assigned case id # xxxxxxxxxxxxxx. You 
will receive a response within one business day.

Note:
Do not reply to this email ( websupport@webrt.amcc.com ). Emails sent to 
websupport@webrt.amcc.com will not receive a response.
To check the status of your case, go to https://www.3ware.com and login.

Thank you indeed!
<<<

Well, they responded within 23-26 hours on average, only to request 
information, that was given in the very first post! In the end (a week 
later) they concluded: the problem cannot be solved without replacing the  
firmware and reinstalling the array! The array couldn't be restored from 
degraded mode - they blamed the samsung drives for it. 

Since then I replaced all my 3ware controllers with Areca controllers and 
haven't regretted it, but I haven't done any serious measurement (I mostly 
care for reliability, btw) but they where noticably faster.

Cheers,
Pete
