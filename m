Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbZBXShc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbZBXShc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 13:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbZBXShU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 13:37:20 -0500
Received: from mx0.towertech.it ([213.215.222.73]:34029 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751652AbZBXShT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 13:37:19 -0500
Date: Tue, 24 Feb 2009 19:37:08 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: Geert.Uytterhoeven@sonycom.com, Richard Zidlicky <rz@linux-m68k.org>,
       linux-parisc@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       David@ozlabs.org, Kyle McMartin <kyle@mcmartin.ca>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Woodhouse <dwmw2@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [rtc-linux] Re: [PATCH/RFC 0/5] Generic RTC class driver
Message-ID: <20090224193708.5f8be86c@i1501.lan.towertech.it>
In-Reply-To: <alpine.LRH.2.00.0902241848500.544@vixen.sonytel.be>
References: <1235144809-32468-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
	<20090220170454.04382e9e@i1501.lan.towertech.it>
	<alpine.LRH.2.00.0902231319170.22762@vixen.sonytel.be>
	<20090223160506.04e347c7@i1501.lan.towertech.it>
	<alpine.LRH.2.00.0902241848500.544@vixen.sonytel.be>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009 18:56:03 +0100 (CET)
Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> 
> On Mon, 23
> > 
> >  I'd start writing a working driver and then see how we should eventually
> >  adapt the rtc subsystem to cope with your needs.
> 
> OK, so here's a first example: rtc-ps3.
> 
> Note that this single patch adds 100+ lines of code, while my previous patch
> series removed 500+ lines of code, while solving the autoloading problem for
> several ppc and m68k platforms.

 This patch has a much cleaner approach, imho.

> Converting all (ca. 20?) ppc and m68k RTC support code into individual RTC
> class drivers would add ca. 100+ lines of code for each individual driver.



 How different are all of those boards? It's simply a matter
 of parameters and offsets? can we group them somehow?

 
-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

