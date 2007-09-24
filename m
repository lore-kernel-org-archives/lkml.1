Return-Path: <linux-kernel-owner+w=401wt.eu-S1760691AbXIXRhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760691AbXIXRhg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756028AbXIXRh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:37:29 -0400
Received: from www17.your-server.de ([213.133.104.17]:50416 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639AbXIXRh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:37:28 -0400
Message-ID: <46F7F5C6.3030909@m3y3r.de>
Date: Mon, 24 Sep 2007 19:37:10 +0200
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: nigel@suspend2.net, Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
References: <1190266447.21818.17.camel@caritas-dev.intel.com>	<20070920100941.GA12157@atrey.karlin.mff.cuni.cz>	<200709211024.35991.nigel@nigel.suspend2.net> <20070920180623.5d7da7b9.akpm@linux-foundation.org>
In-Reply-To: <20070920180623.5d7da7b9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton schrieb:
> On Fri, 21 Sep 2007 10:24:34 +1000 Nigel Cunningham <nigel@nigel.suspend2.net> wrote:
>
>   
>> Hi Andrew.
>>
>> On Thursday 20 September 2007 20:09:41 Pavel Machek wrote:
>>     
>>> Seems like good enough for -mm to me.
>>>
>>> 									Pavel
>>>       
>> Andrew, if I recall correctly, you said a while ago that you didn't want 
>> another hibernation implementation in the vanilla kernel. If you're going to 
>> consider merging this kexec code, will you also please consider merging 
>> TuxOnIce?
>>
>>     
>
> The theory is that kexec-based hibernation will mainly use preexisting
> kexec code and will permit us to delete the existing hibernation
> implementation.
>
> That's different from replacing it
Before replacing existing hibernation implementations, someone should
fix kexec for i386 (maybe others?) EFI systems...


