Return-Path: <linux-kernel-owner+w=401wt.eu-S1945928AbXC3DzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945928AbXC3DzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 23:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945930AbXC3DzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 23:55:00 -0400
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67]:58245 "EHLO
	webmail-outgoing.us4.outblaze.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1945928AbXC3DzA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 23:55:00 -0400
X-Greylist: delayed 19958 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Mar 2007 23:55:00 EDT
X-OB-Received: from unknown (205.158.62.133)
  by wfilter.us4.outblaze.com; 30 Mar 2007 03:54:57 -0000
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
From: "Elliott Johnson" <ejohnson@linuxmail.org>
To: linux-kernel@vger.kernel.org
Date: Fri, 30 Mar 2007 11:54:57 +0800
Subject: Re: strange high system cpu usage.
X-Originating-Ip: 209.209.36.196
X-Originating-Server: ws5-3.us4.outblaze.com
Message-Id: <20070330035457.57A4124753@ws5-3.us4.outblaze.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>What problem are you trying to solve?  IOW, how do you know it's not
>just an artifact of diferent load average calculation between 2.4 and
>2.6?
>
>Are you actually seeing reduced throughput/performance?  Or are you
>just looking at load average?
>
>Lee

Well the problem is apparent, we are having abnormally high cpu usage.  It's about a 
20-40% performance hit.

The load calculations were not between 2.4 and 2.6 kernel versions, but between 2.6.8 and 
2.6.19.  Sorry if this wasn't very clear from my last email.

In trying to diagnose the problem I also looked at memory stats (vmstat) and found the 
'buffered' memory statistic way off from the comparable debian (2.6.8) install (0-300kb 
versus 500mb).

The vmstat man page has little information on this statistic and there seems to be varying
explanations on the web.  I was hoping for a decisive explanation (or link) and possibly 
advice in toggling this value (or reasons not to).

I'm still trying to work on this at my end.  Some recent tests show that it might be
related to the megasas driver or the large number of small files we are using on a xfs
formated 10T array.  I'll keep at it.

Thanks for your response,

-Elliott

=
Search for products and services at: 
http://search.mail.com

-- 
Powered by Outblaze
