Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbYH2I5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbYH2I5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 04:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbYH2I52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 04:57:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62290 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbYH2I51 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 04:57:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: leoli@freescale.com
Subject: Re: [PATCH] usb: add Freescale QE/CPM USB peripheral controller driver
Date: Fri, 29 Aug 2008 10:57:20 +0200
User-Agent: KMail/1.9.9
Cc: linuxppc-dev@ozlabs.org, greg@kroah.com, linux-usb@vger.kernel.org,
       dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org
References: <1219916613-28827-1-git-send-email-leoli@freescale.com> <200808281704.20999.arnd@arndb.de> <1220000265.30607.10.camel@Gundam>
In-Reply-To: <1220000265.30607.10.camel@Gundam>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808291057.20612.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18FfSubivxRb3EC5oUcf76RTYTMm5+PQTo/b7h
 CcmiWRc/y7COmDRWiS2v93WARxf7lU2NjSUoL8i44DcokJ6R0X
 7NLzQrYQ+uKcLpIK8y1Rg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 August 2008, Li Yang wrote:
> 
> > Not a problem, but an observation: Most new code uses work queues instead
> > of tasklets these days, which gives you more predictable real time
> > latencies.
> > If you don't have a specific reason to prefer a tasklet, just use
> > a workqueue here.
> 
> Is this truly a trend?  Work queue is more flexible but it has higher
> latency.  Why are work queues preferred?

Most drivers don't need the low irq to bottom half latency. As I said,
not a problem at all, just my observation. In 2.6.27, we have around
three times more new workqueue usages than new tasklet usages. My
feeling from doing reviews was that it would be closer to a factor
of ten, but I guess I was wrong in that.

	Arnd <><
