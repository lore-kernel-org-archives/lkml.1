Return-Path: <linux-kernel-owner+w=401wt.eu-S1759885AbYFPHdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759885AbYFPHdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 03:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbYFPHdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 03:33:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:14589 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbYFPHdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 03:33:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Y8sjwGhBCu8La8u505wX51ntxTE5DzN8aRRKdWKub7LIcUDaZV/xlH0ectV8nmJ3yt
         X3cLVPvKWPATDTSTBb98zzQEQgDHvbrWUZOVkCqerbAnrXsCGvpTHTQvz0Bno1KPV6Bl
         1jEbgTdyM3WW74H/hqr6a1f30A6ZFa/ndcGWA=
Message-ID: <a5bf86a80806160033n28e101e1s35670a946f3ca57b@mail.gmail.com>
Date: Mon, 16 Jun 2008 10:33:00 +0300
From: "Lior Dotan" <liodot@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [Bug 10866] /dev/rtc was missing until I disabled CONFIG_RTC_CLASS
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       a.zummo@towertech.it,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org, rtc-linux@googlegroups.com
In-Reply-To: <20080616002359.GC1407@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
	 <dCRO4tbfLzK.A.rFC.L2vSIB@albercik>
	 <20080613193302.GA1716@cs181133002.pp.htv.fi>
	 <a5bf86a80806131255w704745d7mc109c13669ac9c68@mail.gmail.com>
	 <20080613212023.GB1716@cs181133002.pp.htv.fi>
	 <a5bf86a80806150115q2d3ee545y84bae48f84d4fe96@mail.gmail.com>
	 <20080616002359.GC1407@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 3:24 AM, Adrian Bunk <bunk@kernel.org> wrote:
> On Sun, Jun 15, 2008 at 11:15:23AM +0300, Lior Dotan wrote:
>> On Sat, Jun 14, 2008 at 12:20 AM, Adrian Bunk <bunk@kernel.org> wrote:
>> >
>> > What is the output of "grep RTC_ .config" on your old .config?
>>
>> Here it is:
>
> Thanks.
>
>>...
>> CONFIG_RTC_CLASS=y
>>...
>> # CONFIG_RTC_DRV_CMOS is not set
>>...
>
> That means the support for the PC RTC is disabled.
>
> Honestly, I do not think we can handle all possible misconfigurations
> when switching to the new RTC drivers automatically.

In that case my configuration was indeed bogus and this bug can be closed.

> cu
> Adrian
>

Cheers,
Lior.
