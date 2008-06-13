Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbYFMTzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbYFMTzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 15:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbYFMTzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 15:55:41 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:56906 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbYFMTzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 15:55:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=u7tnqrmgzmPORUPNvPdmGagJrD6WuC8taJCud1pyMGBtnLDAeJkYgjPdEMMfw2gxgO
         N/7ueieztDSEMJcMEK+sQW+E1PhYNY4KIenXYCr9oayChsTC/gC5oiO3q0OZUaDYTwDj
         ObGJdC/9Eo2kLlpAsRhEf0B7CxrjwNZLW1+iU=
Message-ID: <a5bf86a80806131255w704745d7mc109c13669ac9c68@mail.gmail.com>
Date: Fri, 13 Jun 2008 22:55:38 +0300
From: "Lior Dotan" <liodot@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [Bug 10866] /dev/rtc was missing until I disabled CONFIG_RTC_CLASS
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       a.zummo@towertech.it,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org, rtc-linux@googlegroups.com
In-Reply-To: <20080613193302.GA1716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
	 <dCRO4tbfLzK.A.rFC.L2vSIB@albercik>
	 <20080613193302.GA1716@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 10:33 PM, Adrian Bunk <bunk@kernel.org> wrote:
> On Sat, Jun 07, 2008 at 10:42:57PM +0200, Rafael J. Wysocki wrote:
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.25.  Please verify if it still should be listed.
>>
>>
>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=10866
>> Subject               : /dev/rtc was missing until I disabled CONFIG_RTC_CLASS
>> Submitter     : Lior Dotan <liodot@gmail.com>
>> Date          : 2008-06-05 15:04 (3 days old)
>> References    : http://marc.info/?l=linux-kernel&amp;m=121267834521432&amp;w=4
>
> Where are we regarding this entry in the 2.6.26-rc regression list?
>
> I'd agree with David that CONFIG_RTC_CLASS disabling CONFIG_RTC is a fix
> and not a 2.6.26-rc regression.
>
> Does anyone disagree with this?
>
>
> I'm not sure whether this was Lior's problem or another issue I'm seeing
> on my computer (static /dev, no udev):
>
> /dev/rtc (major 10, minor 135) does not seem to exist, and I'd call this
> a functional regression of the new drivers.
>
> Could this be fixed?
>
>
> cu
> Adrian
>
> --

I don't know if it helps you to decide but the way I got to this
configuration is by copying my working 2.6.25 .config file and running
make oldconfig. I think this scenario is common when upgrading to a
newer version so you should make sure it doesn't generate an invalid
configuration.

Lior.
