Return-Path: <linux-kernel-owner+w=401wt.eu-S1757600AbYFIQlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbYFIQlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 12:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbYFIQl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 12:41:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:23829 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbYFIQl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 12:41:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,613,1204531200"; 
   d="scan'208";a="392567049"
Message-ID: <484D5CCB.10302@intel.com>
Date: Mon, 09 Jun 2008 09:39:39 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080417)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Pavel Machek <pavel@suse.cz>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, len.brown@intel.com,
       cpufreq@lists.linux.org.uk, davej@codemonkey.org.uk
Subject: Re: bug? acpi p-state + ondemand keeps dropping max freq
References: <20080606140846.GA9580@ucw.cz>	<20080607213918.GC1746@elf.ucw.cz> <20080607145435.4afc9812@infradead.org>
In-Reply-To: <20080607145435.4afc9812@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jun 2008 16:41:25.0413 (UTC) FILETIME=[A8412D50:01C8CA4F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Sat, 7 Jun 2008 23:39:18 +0200
> Pavel Machek <pavel@suse.cz> wrote:
> 
>>> # echo 1866000 > scaling_max_freq ; cat scaling_max_freq
>>> 800000
>>> # echo 1866000 > scaling_max_freq ; cat scaling_max_freq
>>> 800000
>>>
>>>
>>> This renders my Dothan to utterly poor speeds. (standard T43)
>>>
>>> performance cpufreq governor makes no difference - I still can't
>>> change the frequency upper/lower values.
>> Hmm, I have similar problem in Novell bugzilla, on very different hw:
>>
>> https://bugzilla.novell.com/show_bug.cgi?id=396311
>>
>> 								Pavel
>>
> 
> 
> are either of you running gnome-power-manager or kpowersaved ?
> sometimes these programs (and more likely, the patches added by a
> distro maintainer who doesn't fully realize how power works) tend to
> muck with kernel settings around CPU frequency that they have
> absolutely no business touching...

I neither run gnome nor kde. there's nothing running on this box that is managing
power settings.

Auke


