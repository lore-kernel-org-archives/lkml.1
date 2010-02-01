Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab0BAEea (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 23:34:30 -0500
Received: from mail-yw0-f179.google.com ([209.85.211.179]:38962 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab0BAEe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 23:34:28 -0500
X-Greylist: delayed 1742 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 Jan 2010 23:34:28 EST
Message-ID: <4B665322.2060005@gawab.com>
Date: Sun, 31 Jan 2010 20:05:54 -0800
From: Justin Madru <jdm64@gawab.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091215 Shredder/3.0
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Forward porting 2.4 driver
References: <4B634540.9070306@gawab.com> <20100129203613.GF27907@1wt.eu>
In-Reply-To: <20100129203613.GF27907@1wt.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2010 12:36 PM, Willy Tarreau wrote:
> Hello,
>
> On Fri, Jan 29, 2010 at 12:29:52PM -0800, Justin Madru wrote:
>    
>> I have this Belkin router with the default firmware running 2.4.30.
>> Belkin provided the source code as specified by the GPL. I was wondering
>> how hard it would be to upgrade the kernel from 2.4.30 to 2.4.37.7. I
>> know that 2.6 would be extremely hard because the driver model has
>> changed so much. But, what changes happened between .30 and .37 that
>> would make it difficult to upgrade the code? Did the driver model or
>> other drastic changes happen? Could I just do a file diff; import the
>> new files Belkin added and update the make files and kconfig?
>>      
> it will very likely work even without any change. I have some drivers
> in my private tree which were written for various versions between
> 2.4.23 and 2.4.33, most of which apply without problem. In general
> the only conflicts you can get are in Config.in or the makefiles
> where the patch wants to add one line to enable the driver, because
> the context might have changed. But that's really obvious to fix.
>
>    
>> The CPU and wireless card are based on the Ralink 2880/2860 or something
>> like that.
>>      
> Well, if you have the 2.4 driver and the hardware, it could also be
> a nice exercise to try to port it to 2.6. It's not necessarily that
> much complicated, as there are several drivers which are compatible
> with both 2.4 and 2.6. They generally rely on some #define to rename
> some struct members or use different macros depending on versions.
>
> Regards,
> Willy
>
>
>    
Well, it's good that the driver might easily be updated to the latest 2.4.

I did a diff of the source code that was provided against 2.6.30. 
Unfortunately, it looks like there's been more changes to the code than 
simply adding drivers. Updates all across the tree have been made, some 
minor that would be an easy merge. But some seem to be more involved 
changes. Any suggestions on merging the code?

Justin
