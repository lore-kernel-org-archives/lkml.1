Return-Path: <linux-kernel-owner+w=401wt.eu-S1761639AbZEGRGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761639AbZEGRGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 13:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758627AbZEGRGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 13:06:08 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:29149 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757257AbZEGRGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 13:06:07 -0400
X-Greylist: delayed 692 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 May 2009 13:06:06 EDT
X-RZG-AUTH: :OUwRflWtc/HJSDZEw3LQ3i60a5MmrHxmAfkINEnIhH6pzDtI4Q6iVU0K
X-RZG-CLASS-ID: mo05
Message-ID: <4A03129A.90105@acm.org>
Date: Thu, 07 May 2009 18:55:54 +0200
From: U Kuehn <ukuehn@acm.org>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Nigel Cunningham <nigel@tuxonice.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm@lists.linux-foundation.org, tuxonice-devel@lists.tuxonice.net,
       linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <20090507120948.GA1531@ucw.cz>
In-Reply-To: <20090507120948.GA1531@ucw.cz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>> To briefly summarise the advantages to merging TuxOnIce:
>>
>> - Support for multiple swap devices
>> - Support for non-swap (an ordinary file can be used)
>> - Uses cryptoapi (LZO support, more than 2x speed of uncompressed data!)
>> - Asynchronous I/O, readahead, multithreaded. Get the maximum throughput
>>   possible with your hardware.
>> - Userspace user interface that lets you abort hibernating and abort
>>   resuming, get nice progress display etc.
> 
> All these are either done by uswsusp already, or could be done w/o
> modifying kernel code.
> 

Given that tuxonice DOES work reliably with dm-crypt encrypted swap
partitions, does uswsusp offer this functionality? Looking into the docs
on the sourceforge site does not give any information about this point.

Further, being someone with a crypto background, the userland suspend
helper does have some issues with the password/key handling:
1) no support for keys containing a 0 byte. (cryptsetup can handle this)
2) the rsa functionality seems to use the unsound practice to encrypt
the symmetric key directly without any padding (aka encoding in libgcrypt).

This is, unfortunately, something really fundamenta...

Just to add my 2 cents...

Ulrich
