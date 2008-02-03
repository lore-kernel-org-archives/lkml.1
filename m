Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbYBCUDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbYBCUDZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 15:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbYBCUDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 15:03:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59086 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbYBCUDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 15:03:15 -0500
Message-ID: <47A61DD6.7040502@zytor.com>
Date: Sun, 03 Feb 2008 12:02:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: wakeup code translated to .c
References: <20080130120111.GB22820@elf.ucw.cz> <200802031857.02422.rjw@sisk.pl> <20080203181648.GA1629@elf.ucw.cz> <20080203184931.GA2648@uranus.ravnborg.org>
In-Reply-To: <20080203184931.GA2648@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Sun, Feb 03, 2008 at 07:16:48PM +0100, Pavel Machek wrote:
>> Hi!
>>
>>>> This version works on 32-bit, and builds on 64-bit (but I'm pretty
>>>> sure it does not work. 32-bit code probably needs to go into rm/....)
>>>>
>>> Do you have an updated version or is this the latest one?
>> I'm glad you ask ;-). Here's reasonably-recent version (I have
>> slightly cleaner one, but it got obscured by 2.6.24-git merge), I
>> eventually got it to work on 64-bit, by reusing trampoline.S code.
>>
>> 								Pavel
>> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> Hi PAvel.
> 
> Before you submit this for real we need me to take a deper
> look into your Makefiles.
> We do not want this duplication between boot and acpi.
> And the way you deal with code sharing from boot/ is not
> OK either.
> 
> But I do have a few other things pending before I have time
> so please ping me in a week or two.
> 

Don't blame Pavel for that.  That has a quick hack I threw together to 
give him something at all to work with.

	-hpa
