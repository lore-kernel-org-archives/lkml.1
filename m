Return-Path: <linux-kernel-owner+w=401wt.eu-S932768AbZAPX47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768AbZAPX47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 18:56:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbZAPX4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 18:56:50 -0500
Received: from relay2.sgi.com ([192.48.179.30]:58945 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751195AbZAPX4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 18:56:50 -0500
Message-ID: <49711EBC.5050101@sgi.com>
Date: Fri, 16 Jan 2009 15:56:44 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@suse.cz>, Jeff Chua <jeff.chua.linux@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.29-rc1: thinkpad problems during resume
References: <20090113081316.GA2292@elf.ucw.cz> <b6a2187b0901130721y51b9618uef6efb84b7784d6@mail.gmail.com> <20090116143905.GA1933@elf.ucw.cz> <200901162306.11853.rjw@sisk.pl>
In-Reply-To: <200901162306.11853.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Friday 16 January 2009, Pavel Machek wrote:
>> On Tue 2009-01-13 23:21:17, Jeff Chua wrote:
>>> On Tue, Jan 13, 2009 at 10:36 PM, Pavel Machek <pavel@suse.cz> wrote:
>>>> resumes fine with CONFIG_SMP unset.
>>> On my X60s, I had problem with s2ram, and I switch to the following ...
>>>
>>> echo mem > /sys/power/state
>>>
>>> Try and see if it works for you.
>> I tried that; unlike s2ram, this actually produces some oopses that
>> can be viewed. Unfortunately, they scroll a bit too fast.
>>
>> cpu hotplug vs. cpufreq seems to be responsible in my case, looking at
>> the logs from "echo 1 > online".
> 
> There are three patches from Mike Travis that can help:
> http://lkml.org/lkml/2009/1/16/377
> 
> Thanks,
> Rafael

Note that these don't really fix anything, just replaces the current
method of using set_cpus_allowed with the work_on_cpu call.  If
the laptop worked before the [bad] patch, then it should work again
now with this one.

Thanks,
Mike


