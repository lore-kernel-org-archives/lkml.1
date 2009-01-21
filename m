Return-Path: <linux-kernel-owner+w=401wt.eu-S932151AbZAUDjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151AbZAUDjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 22:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755523AbZAUDjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 22:39:03 -0500
Received: from rex.securecomputing.com ([203.24.151.4]:42986 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754191AbZAUDjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 22:39:00 -0500
Message-ID: <497698D2.1050804@snapgear.com>
Date: Wed, 21 Jan 2009 13:38:58 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: torvalds@linux-foundation.org, arnd@arndb.de, gerg@uclinux.org,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org, sam@ravnborg.org, uclinux-dev@uclinux.org,
       zippel@linux-m68k.org
Subject: Re: [git pull] m68k and m68knommu merge of includes
References: <200901210058.n0L0wjdf005545@localhost.localdomain> <1232502275.5653.2.camel@brick>
In-Reply-To: <1232502275.5653.2.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harvey,

Harvey Harrison wrote:
> On Wed, 2009-01-21 at 10:58 +1000, Greg Ungerer wrote:
>> Hi Linus,
>>
>> Please consider pulling this merge of the m68k and m68knommu include files.
>> It comepletely moves include/asm-m68k to arch/m68k/include as part of the
>> process, and ultimately results in both m68k and m68knommu arch code using
>> the same set of includes. More cleanup can follow, but this is the
>> necessary first step.
>>
>> Thanks
>> Greg
> 
> I think you need to check your arch/m68k/include/asm/swab.h as I get an
> empty file when I pull this.  It looks like it needs a conditional 
> include of swab_mm/swab_no similar to the other files.

Yes, something went wrong there...


> Also, because of the byteorder changes, it looks like you don't need
> a separate byteorder_mm/no as they both just include the generic
> include/linux/byteorder/big_endian.h

Are you happy to just apply your follow up patch to fix these issues,
after this has been pulled?

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear, a McAfee Company                  PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
