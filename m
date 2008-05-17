Return-Path: <linux-kernel-owner+w=401wt.eu-S1760934AbYEQWOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760934AbYEQWOS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 18:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757927AbYEQWOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 18:14:11 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:46765 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755403AbYEQWOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 18:14:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=CWR1jwMpS2CPkB3ldNSyjUXjafrsDCaRWe6ytDCyU/ChJ1K1Syd/R41pIFbCA9xvxbmS2tkZ4HIBlLHgr+RoFpDGjfxc7pX2Yn42X9OWMGbdcc7/kfMxLiSd3KdebmSdAe5jHlzSo5wajHBkpveHFk7XWUL36K+Cb+3+MOPIEi8=  ;
X-YMail-OSG: fVCq0UcVM1lfH75fQ_kFcwOeBQxBYZhS4A2iY5uYqzgVDlxRL3uQbCxwng1S.x45eiMgAOpccOrTY85wnrsG8GyV.LCevvi_Gc9zlA5AGjI6IkUPtGbT5E.t_VdB6W2aZV0-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
Date: Sat, 17 May 2008 15:14:06 -0700
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Trent Piepho <tpiepho@freescale.com>,
       hartleys <hartleys@visionengravers.com>,
       Ben Nizette <bn@niasdigital.com>, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
References: <200804281239.51729.david-b@pacbell.net> <20080428134649.44cf239c.akpm@linux-foundation.org> <20080502203637.GG3956@ucw.cz>
In-Reply-To: <20080502203637.GG3956@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200805171514.07619.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 May 2008, Pavel Machek wrote:
> 
> > >   echo "export 23" > /sys/class/gpio/control
> > >     ... will gpio_request(23, "sysfs") and gpio_export(23); use
> > >     /sys/class/gpio/gpio-23/direction to configure it.
> > >   echo "unexport 23" > /sys/class/gpio/control
> > >     ... will gpio_free(23)
> > 
> > hm, does ths sysfs one-value-per-file rule apply to writes?
> 
> Having seen ibm acpi interface... yes, that rule should be aplied for
> writes, too.

The latest version of this patch, which I'll post soonish,
follows the suggestion to have one file for the "export"
operation and another for "unexport".


> What about mkdir gpio-N to export it?

Ugh.  That would create way more complication than I want
to see here.  I thought about that early on, and decided
that was Not The Way To Go.

- Dave

