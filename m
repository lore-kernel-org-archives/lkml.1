Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654AbZG0OyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbZG0OyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 10:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZG0OyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 10:54:18 -0400
Received: from xdsl-87-78-165-2.netcologne.de ([87.78.165.2]:56512 "EHLO
	horst.phuk.ath.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbZG0OyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 10:54:18 -0400
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jul 2009 10:54:17 EDT
Message-ID: <4A6DBD51.6040103@phuk.ath.cx>
Date: Mon, 27 Jul 2009 16:44:33 +0200
From: list@phuk.ath.cx
User-Agent: Thunderbird 2.0.0.22 (X11/20090723)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Oliver Neukum <oliver@neukum.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13624] usb: wrong autosuspend initialization
References: <Pine.LNX.4.44L0.0907271041040.5614-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0907271041040.5614-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Sun, 26 Jul 2009, Rafael J. Wysocki wrote:
> 
>> This message has been generated automatically as a part of a report
>> of regressions introduced between 2.6.29 and 2.6.30.
>>
>> The following bug entry is on the current list of known regressions
>> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
>> be listed and let me know (either way).
>>
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13624
>> Subject		: usb: wrong autosuspend initialization
>> Submitter	:  <list@phuk.ath.cx>
>> Date		: 2009-06-25 18:18 (32 days old)
> 
> There's some question as to whether this should be considered a kernel 
> bug.  The kernel isn't doing anything wrong; the problem is that 
> various userspace programs enable autosuspend for devices that can't 
> support it properly.
> 
> Alan Stern
> 

I'm currently working on a patch for laptop_mode. The maintainer tells 
me there's work going on in the kernel to blacklist USB devices that 
don't implement autosuspend correctly (like mice turning their light 
off, etc...). Is that true?
