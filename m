Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbYHAKHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbYHAKHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 06:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYHAKG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 06:06:59 -0400
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67]:40551 "EHLO
	webmail-outgoing.us4.outblaze.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751788AbYHAKG7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 06:06:59 -0400
X-OB-Received: from unknown (205.158.62.232)
  by wfilter.us4.outblaze.com; 1 Aug 2008 10:06:57 -0000
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
From: "Halesh S" <halesh.s@india.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Cc: kosaki.motohiro@jp.fujitsu.com,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, madhvesh.s@ap.sony.com,
       halesh.sadashiv@ap.sony.com
Date: Fri, 1 Aug 2008 04:36:57 -0530
Subject: Re: mlock() return value issue in kernel 2.6.23.17
X-Originating-Ip: 125.17.166.34
X-Originating-Server: ws5-11.us4.outblaze.com
Message-Id: <20080801100657.2CF84CB59C@ws5-11.us4.outblaze.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> ----- Original Message -----
> From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
> To: "Halesh S" <halesh.s@india.com>
> Subject: Re: mlock() return value issue in kernel 2.6.23.17
> Date: Fri, 01 Aug 2008 17:56:55 +0900
> 
> 
> Hi
> 
> > Thanks everyone.
> > I confirm that the patch fixes the issue with Rlimit and invalid address.
> >
> > Signed-off-by: halesh.sadashiv@ap.sony.com
> 
> No.
> your test program need run as root.
> then, it doesn't test rlimit.

>

Sorry, test program not checks the rlimit.as it run as root.
Your patch fixes the issue for invalid address.

It confirms the SUSv3.

Signed-off-by: halesh.sadashiv@ap.sony.com


Thanks,
Halesh







=


-- 
_______________________________________________
Search for products and services at: 
http://search.mail.com
