Return-Path: <linux-kernel-owner+w=401wt.eu-S1756276AbYCTPvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbYCTPvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 11:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbYCTPuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 11:50:55 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:40161 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbYCTPuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 11:50:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=UVkMr8hWHJxQHVjxQVDCeZYzlGi5Jb5XHvoCMRUXaPdP524H8OE0U/RpIe1iTjrB7h8usHdjyHcF/4DSr8DVdMCrRUFMSQF824lGf1YDK8DjiVFh0nxsalrEBcPRgiBiEzAt+JFisi9M9tAUT3bYPIb/7xlzgumk51BEsvp7sDY=
Message-ID: <47E287D4.3060906@gmail.com>
Date: Thu, 20 Mar 2008 18:50:44 +0300
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Pavel Machek <pavel@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: suspend slow in 2.6.25-rc6 (was Re: Suspend and hibernation patchset
 against -rc6)
References: <200803120129.25585.rjw@sisk.pl> <200803172317.33745.rjw@sisk.pl> <20080318130642.GA1609@elf.ucw.cz> <20080318130710.GB1609@elf.ucw.cz> <alpine.LFD.1.00.0803181028400.3020@woody.linux-foundation.org> <20080318232037.GA1670@elf.ucw.cz> <20080320151931.GD5615@khazad-dum.debian.net>
In-Reply-To: <20080320151931.GD5615@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Wed, 19 Mar 2008, Pavel Machek wrote:
>   
>>     Also, for polling mode to work on Acers, we need
>>     to insert a delay.
>>     
>
> Can we, in the future, always trigger any such performance damaging "fixups"
> based on DMI white/black lists?  As a rule?
>   
Poll mode is not supposed to be entered on any non-broken HW.
The fact that it happens now with Thinkpads at suspend is a bug.
EC region should not be accessed with interrupts of GPEs disabled.
> This is not the first time I see a vendor push broken crap, and everyone
> else who did it right get the shaft, because people don't like to add
> quirks to common code.  We get performance enhancement features disabled,
> mdelays added...
>
> And for the do-as-windows-does crowd, they do it on vendor­issued device
> drivers, which obviously don't hork everyone else's devices.  Our equivalent
> solution is to key things to DMI matches.   This is worth keeping in mind,
> because the ACPI subsystem seems to be a common target for such bad
> behaviour.
>
>   

