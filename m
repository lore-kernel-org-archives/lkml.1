Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbZLDErd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbZLDErd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 23:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbZLDEra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 23:47:30 -0500
Received: from rex.securecomputing.com ([203.24.151.4]:44379 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755800AbZLDEr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 23:47:29 -0500
Message-ID: <4B18947C.9090208@snapgear.com>
Date: Fri, 04 Dec 2009 14:47:56 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Steven King <sfking00@yahoo.com>
CC: linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
       uclinux-dev@uclinux.org, Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH] [Repost without wordwrapping] Merge m68k and m68knommu
References: <200910181655.40579.sfking00@yahoo.com> <200911100055.43227.sfking00@yahoo.com>
In-Reply-To: <200911100055.43227.sfking00@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Steven King wrote:
> On Sunday 18 October 2009 04:55:40 Steven King wrote:
>> This is a script and patch to merge the m68knommu arch into m68k.
> 
> Ping.

Sorry, I have just not had time to look at this yet.
Promise to find some time soon to have a closer look soon :-)

Regards
Greg



>> The script was inspired by the script Sam Ravnborg used to merge the
>> includes from m68knommu. For those files common to both arches but
>> differing in content, the m68k version of the file is renamed to
>> <file>_mm.<ext> and the m68knommu version of the file is moved into the
>> corresponding m68k directory and renamed <file>_no.<ext> and a small
>> wrapper file <file>.<ext> is used to select between the two version.
>> Files that are common to both but don't differ are removed from the
>> m68knommu tree and files and directories that are unique to the
>> m68knommu tree are moved to the m68k tree. Finally, the arch/m68knommu
>> tree is removed.
>>
>> To select between the the versions of the files, the wrapper uses
>>
>> #ifdef CONFIG_MMU
>> #include <file>_mm.<ext>
>> #else
>> #include <file>_no.<ext>
>> #endif
>>
>> The patch modifies the toplevel Makefile so that ARCH=m68knommu still
>> works (by setting SRCARCH=m68k) and adds the m68knommu Kconfig and
>> Makefile to the m68k Kconfig and Makefile, using the definition of ARCH
>> to select which values to use.
>>
>> Thus when building for either a m68k or an m68knommu target, one still
>> specifies either ARCH=m68k or ARCH=m68knommu and everything should
>> build EXACTLY as it did pre-merge.  (I think).
>>
>>
>> Signed-off-by: Steven King <sfking@fdwdc.com>



-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
