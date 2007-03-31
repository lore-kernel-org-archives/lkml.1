Return-Path: <linux-kernel-owner+w=401wt.eu-S933310AbXCaCIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310AbXCaCIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 22:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933314AbXCaCIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 22:08:39 -0400
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67]:58396 "EHLO
	webmail-outgoing.us4.outblaze.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933310AbXCaCIi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 22:08:38 -0400
X-OB-Received: from unknown (205.158.62.131)
  by wfilter.us4.outblaze.com; 31 Mar 2007 02:08:37 -0000
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
From: "Elliott Johnson" <ejohnson@linuxmail.org>
To: "Elliott Johnson" <ejohnson@linuxmail.org>
Cc: linux-kernel@vger.kernel.org
Date: Sat, 31 Mar 2007 10:08:37 +0800
Subject: Re: strange high system cpu usage.
X-Originating-Ip: 209.209.36.196
X-Originating-Server: ws5-1.us4.outblaze.com
Message-Id: <20070331020837.C597743FCD@ws5-1.us4.outblaze.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lee

Thanks for your help.  In testing different kernels we found that using an unpatched kernel from kernel.org seems to fix the problem.  I'm assuming that a patch added in the gentoo-sources patch set was creating the problem.  Our once 8 minute untar is now down to 7-8 seconds with a vanilla 2.6.18.6 kernel.

If anyone is interested in our oprofile code or other info, just ask and I'll post it.  Otherwise I'll be reporting this to the gentoo developers.

-E

> ----- Original Message -----
> From: "Elliott Johnson" <ejohnson@linuxmail.org>
> To: linux-kernel@vger.kernel.org
> Subject: Re: strange high system cpu usage.
> Date: 	Fri, 30 Mar 2007 11:54:57 +0800
> 
> 
> > What problem are you trying to solve?  IOW, how do you know it's not
> > just an artifact of diferent load average calculation between 2.4 and
> > 2.6?
> >
> > Are you actually seeing reduced throughput/performance?  Or are you
> > just looking at load average?
> >
> > Lee
> 
> Well the problem is apparent, we are having abnormally high cpu 
> usage.  It's about a
> 20-40% performance hit.
> 
> The load calculations were not between 2.4 and 2.6 kernel versions, 
> but between 2.6.8 and
> 2.6.19.  Sorry if this wasn't very clear from my last email.
> 
> In trying to diagnose the problem I also looked at memory stats 
> (vmstat) and found the
> 'buffered' memory statistic way off from the comparable debian 
> (2.6.8) install (0-300kb
> versus 500mb).
> 
> The vmstat man page has little information on this statistic and 
> there seems to be varying
> explanations on the web.  I was hoping for a decisive explanation 
> (or link) and possibly
> advice in toggling this value (or reasons not to).
> 
> I'm still trying to work on this at my end.  Some recent tests show 
> that it might be
> related to the megasas driver or the large number of small files we 
> are using on a xfs
> formated 10T array.  I'll keep at it.
> 
> Thanks for your response,
> 
> -Elliott
> 
> =
> Search for products and services at:
> http://search.mail.com
> 
> --
> Powered by Outblaze
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

>


=
Search for products and services at: 
http://search.mail.com

-- 
Powered by Outblaze
