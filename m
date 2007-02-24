Return-Path: <linux-kernel-owner+w=401wt.eu-S933580AbXBXW5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933580AbXBXW5l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 17:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933581AbXBXW5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 17:57:41 -0500
Received: from mxout-03.mxes.net ([216.86.168.178]:1821 "EHLO
	mxout-03.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933580AbXBXW5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 17:57:40 -0500
Message-ID: <33524.86.7.220.119.1172357859.squirrel@wmbeta.mxes.net>
In-Reply-To: <20070224030950.074f88d4.akpm@linux-foundation.org>
References: <35472.86.7.220.119.1172237750.squirrel@wmbeta.mxes.net>
    <20070224030950.074f88d4.akpm@linux-foundation.org>
Date: Sat, 24 Feb 2007 22:57:39 -0000 (GMT)
Subject: Re: 2.6.21-rc1: framebuffer/console boot failure
From: "Andrew Nelless" <andrew@nelless.net>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Reply-To: "Andrew Nelless" <andrew@nelless.net>
User-Agent: SquirrelMail/1.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, February 24, 2007 11:09 am, Andrew Morton wrote:
>> On Fri, 23 Feb 2007 13:35:50 -0000 (GMT) "Andrew" <andrew@nelless.net> wrote:
>> Hi,
>>
>>
>> 2.6.21-rc1 fails to boot on my machine. As soon as I switch
>> from grub the screen turns and remains black with no sign of Tux or any output.
>>
>> I've run a git-bisect between 2.6.20 (which works fine) and
>> 2.6.21-rc1 and found the first bad commit to be
>> #59b8175c771040afcd4ad67022b0cc80c216b866 which seems bizarre
>> to me since this is a mostly an ARM commit.
>>
>> I haven't tried to revert this commit because frankly I don't
>> know where to go from there with a multi-parent commit.
>>
>> I'm running on on a Asus A8N-VM CSM motherboard with a single
>> core AMD64 processor, with a nVidia GPU in the PCI-ex slot using the standard VESA frame
>> buffer driver.
>>
>> Relevant config's can be found here:
>> http://homepage.ntlworld.com/anelless/linux/2.6.21-rc1/
>>
>>
>
> and, later,
>
>> I have just discovered 2.6.21-rc1 boots with
>> pci=noacpi ...
>
> Presumably this regression was caused by the ACPI merge.  Are you able to
> capture the dmesg output from the 2.6.20-rc1 boot?  netconsole might be useful here, thanks.
>
> (You get added to the post-2.6.20 regression list, so you'll be hearing
> from us quite a lot for the next month.  Sorry ;))
>


