Return-Path: <linux-kernel-owner+w=401wt.eu-S1759736AbZAMJAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759736AbZAMJAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 04:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbZAMJAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 04:00:20 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:38144 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695AbZAMJAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 04:00:18 -0500
Message-ID: <496C5846.3050809@lougher.demon.co.uk>
Date: Tue, 13 Jan 2009 09:00:54 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Woody Suwalski <woodys@xandros.com>
CC: Matthias Kaehlcke <matthias@kaehlcke.net>, linux-kernel@vger.kernel.org
Subject: Re: [BUG?] SQUASHFS error: Major/Minor mismatch
References: <20090112140822.GB23365@traven> <496BC02A.2020402@xandros.com>
In-Reply-To: <496BC02A.2020402@xandros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Woody Suwalski wrote:
> Phillip Lougher wrote:
>>
>> You have to use the latest version of Mksquashfs in CVS available
>> from http://squashfs.org.
>>
>> git-cvsimport -v -d 
>> :pserver:anonymous@squashfs.cvs.sourceforge.net:/cvsroot/squashfs 
>> squashfs
>>
>> Phillip
>>
> Does not look good! I have squashfs images which work OK in 3.3 and 3.4, 
> but now I try to boot 2.6.29-rc1 and it can not mount my squashfs root 
> partition!
> Does it mean that squashfs4 is not backward-compatible? If so - I can 
> not use it - all my images are generated on 3.3 .. 3.4...
> 

Backwards compatibility was dropped as part of the original review
complaints against mainlining.  The new 4.0 layout was necessary to address
some issues again relating to the original review complaints.  The 4.0
layout is designed to hopefully not require any further modification in the
future.

Ultimately this does mean the Squashfs mainline code will never be able to
read older filesystems.  But, unsquashfs will always be able to read all
filesystem versions, and I'll maintain out-of-tree patches that add
backwards compatibility to the kernel code for those that need it.  This
should be finished in the near future.

Philllip
