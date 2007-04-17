Return-Path: <linux-kernel-owner+w=401wt.eu-S1161386AbXDQW2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161386AbXDQW2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 18:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161384AbXDQW2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 18:28:08 -0400
Received: from smtp112.sbc.mail.mud.yahoo.com ([68.142.198.211]:35481 "HELO
	smtp112.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161388AbXDQW2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 18:28:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=aeIyFSc8itm2rsuMaGgGedfSdL8SMrGJ5wLEc7zloN3FXyqkmb5nK61abuQ9oWlecX/ANO/q+RipO+Rn631Bz0SJo8BYxMbwGc/HeX/wicNArs54wzAQXfDtbM+ksYyBdj8kMJ6pNiT0IB+mesTWLXrmAXqct3pFGvHBNkbDJC8=  ;
X-YMail-OSG: lIo1lmwVM1nhglesD05NVCTQQWlr_WGCGTkWjPf5hpLklcgR7aimGw77K3wJvpIU6Xr0QKMpbQ--
From: David Brownell <david-b@pacbell.net>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH][RFC] Kill off legacy power management stuff.
Date: Tue, 17 Apr 2007 15:28:00 -0700
User-Agent: KMail/1.7.1
Cc: Bill Davidsen <davidsen@tmr.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Robert P. J. Day" <rpjday@mindspring.com>, Pavel Machek <pavel@ucw.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0704122025380.3628@CPE00045a9c397f-CM001225dbafb6> <200704131022.45315.rjw@sisk.pl> <46254666.2020308@tmr.com>
In-Reply-To: <46254666.2020308@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704171528.00861.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 April 2007 3:12 pm, Bill Davidsen wrote:
>  
> One reason was that there are (were?) a number of machines which only 
> powered down properly using apm. It was discussed as part of shutting 
> down after power failure when your UPS is running out of power.

At least the notification mechanism had only the one client (68328serial.c),
so that part should be easily removed even if APM emulation needs some of
the other bits ...
