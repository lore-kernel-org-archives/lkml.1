Return-Path: <linux-kernel-owner+w=401wt.eu-S1761418AbZCSUm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761418AbZCSUm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 16:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761329AbZCSUlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 16:41:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:45379 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761378AbZCSUly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 16:41:54 -0400
Message-ID: <49C2AE0C.8050805@monstr.eu>
Date: Thu, 19 Mar 2009 21:41:48 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org, john.williams@petalogix.com
Subject: Re: Microblaze linux support
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <49C2ACA8.4070503@oracle.com>
In-Reply-To: <49C2ACA8.4070503@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,
> monstr@monstr.eu wrote:
>> Hi all,
>>
>> I think that is the right time to send you next pack with 
>> Microblaze support. It is seventh pack - some previous packs
>> was review by community and I hope there are not any big faults.
>>
>> We tested this kernel on some boards.
>> We have GIT server up and gitweb is available at http://developer.petalogix.com/git/gitweb.cgi
>>
>> All information about git clone you can find on gitweb.
>> This pack is available in for-linus branch. Information about other branches are on gitweb too.
>>
>> More information about microblaze fdt kernel you can find at www.monstr.eu/fdt/
>> If you want to test kernel with microblaze toolchain let me know.
> 
> Hi Michal,
> 
> Is there an x86-hosted cross-tool chain available?
> If so, where?

yes it is. I use old 3.4.1 gcc and we are preparing 4.1.2 version.(We have 4.1.2
for MMU with glibc). I hope will be ready soon. Of course is possible to compile
kernel with that tool too.

The first way is download that code from svn server.

Here is the link directly to svn folder  (Name guest, without password)
https://developer.petalogix.com/pr/internal/petalinux/trunk/tools/linux-i386/microblaze-uclinux-tools/


The second way is download full distribution (360MB)
http://developer.petalogix.com/downloads/petalinux-v0.30-rc1.tar.gz

There is . setting.sh script which only add toolchain to your patches or you can
add it by hand. (Location is in tools/linux-i386/microblaze-uclinux-tools).

If you want gcc 4.1.2 pack for MMU (Just for kernel build) I can provide you
prebuilt package too.

Thanks,
Michal


> 
>> I added only uart16550 and uartlite support - that's enought for first merge.
>>
>>
>> Thanks for you comments and especially for your ACK,
> 
> Thanks,


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
