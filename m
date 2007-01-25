Return-Path: <linux-kernel-owner+w=401wt.eu-S933149AbXAYAgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149AbXAYAgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 19:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933104AbXAYAg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 19:36:26 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:40547 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933116AbXAYAgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 19:36:22 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=sPaoL1ac3dc1Z7tZ8tjVBZsfFkRN8XGJB81n2Mz2ZxUzPfLiF8nF2Xu6BeB33NzRjW9DWvhXxEDHj3luY60f4o/3a2INP5qr9kKF53auHu+RvlzXc/1zT5i4TTFYFAEjdZzv8dTc3M4ktQmyq0zI+eiG4kd0xt+rlWauBtsvjEM=  ;
X-YMail-OSG: 4Ona76sVM1ky.Jp39_.OBcWeEAiZ6gDARngn0KdR48NuIq7j44EzMPeub5DY0E13i1AQAn2TTA--
Message-ID: <45B7FB71.5030603@yahoo.com.au>
Date: Thu, 25 Jan 2007 11:36:01 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.20-rc5: cp 18gb 18gb.2 = OOM killer, reproducible just like
 2.16.19.2
References: <Pine.LNX.4.64.0701211424170.2552@p34.internal.lan> <20070122115703.97ed54f3.akpm@osdl.org> <Pine.LNX.4.64.0701241909120.2930@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0701241909120.2930@p34.internal.lan>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> 
> On Mon, 22 Jan 2007, Andrew Morton wrote:

>>After the oom-killing, please see if you can free up the ZONE_NORMAL memory
>>via a few `echo 3 > /proc/sys/vm/drop_caches' commands.  See if you can
>>work out what happened to the missing couple-of-hundred MB from
>>ZONE_NORMAL.
>>
> 
> Running with PREEMPT OFF lets me copy the file!!  The machine LAGS 
> occasionally every 5-30-60 seconds or so VERY BADLY, talking 5-10 seconds 
> of lag, but hey, it does not crash!! I will boot the older kernel with 
> preempt on and see if I can get you that information you requested.

It wouldn't be a bad idea to recompile the new kernel with preempt on
and get the info from there.

It is usually best to be working with the most recent kernels. We can
always backport any important fixes if we need to.

Thanks,
Nick

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
