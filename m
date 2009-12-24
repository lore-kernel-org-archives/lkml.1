Return-Path: <linux-kernel-owner+w=401wt.eu-S1752744AbZLXDzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbZLXDzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 22:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbZLXDzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 22:55:49 -0500
Received: from mail.windriver.com ([147.11.1.11]:55268 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbZLXDzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 22:55:48 -0500
Message-ID: <4B32E618.4070906@windriver.com>
Date: Wed, 23 Dec 2009 21:55:04 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu, kdb@oss.sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [Kgdb-bugreport] [PATCH 0/37] kgdb,kdb and atomic kernel modesetting
 series
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com> <20091224005654.GA28950@kroah.com>
In-Reply-To: <20091224005654.GA28950@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Dec 2009 03:55:05.0069 (UTC) FILETIME=[E066B9D0:01CA844C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Dec 23, 2009 at 03:19:13PM -0600, Jason Wessel wrote:
>   
>> Back in May 2009 an initial kdb prototype was posted to lkml as an RFC
>> to see if there was sufficient interest to merge kdb and kgdb together.
>>
>> There was enough interest to continue on with the project, and it is
>> now in a state where further work can occur to review, and hopefully
>> merge the code into a future kernel.
>>     
>
> Very cool work, nice job.
>
>   
>> The code included in this series does not include any of the USB code
>> referenced in the presentation.
>>     
>
> I'm guessing that is going to happen sometime later after the main stuff
> is merged in?
>   

That is correct.  The usb code will be worked on after the debug core is
stable and ready to be merged.

There are over 30 patches outstanding in the USB queue.  There are some
tricky problems that remain unsolved with the synchronously polled USB
code.  The current code looks great for a demonstration in one
particular configuration and is ok for debugging a problem if you have
that specific configuration, but that is about as far as it goes.  In
order of maturity and the likely order of contribution would be:

1) Stable USB console support
2) Polled USB keyboard support
3) Bi-directional kgdb over dbgp (EHCI debug interface)
4) Polled kgdboc USB serial support

Jason.
