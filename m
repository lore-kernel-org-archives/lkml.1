Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbXIIPtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbXIIPtf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 11:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbXIIPt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 11:49:27 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:61855 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbXIIPt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 11:49:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ANDFLA5LWHmCvNQexwUJkCRI6KbwGESfMLkzuE1DoGTbdjKAtlBhhBO/6/ch9Rdum+QWLXDk5TMymeMty0m2IC/+2Rj8WE7Fsjt20ZrG9ntgRirnF0xfQDd7lY0IQQ0ulAZxJyWvBg4j2IJZskqqbZ4mnHOHlizN9X5M+cqzAno=
Message-ID: <46E41601.7030600@gmail.com>
Date: Sun, 09 Sep 2007 17:49:21 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, airlied@linux.ie
Subject: Re: X freezes kernel during exit [Re: 2.6.23-rc3-mm1]
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46D17A7A.70609@gmail.com> <46D409FC.1070305@gmail.com> <46E3DCB8.5010709@gmail.com> <20070909054751.cbb27081.akpm@linux-foundation.org> <46E3FE6B.7010209@gmail.com> <20070909141730.GB25798@one.firstfloor.org> <46E4028E.9050007@gmail.com> <20070909143324.GC25798@one.firstfloor.org> <46E40699.7060000@gmail.com> <20070909150158.GD25798@one.firstfloor.org>
In-Reply-To: <20070909150158.GD25798@one.firstfloor.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2007 05:01 PM, Andi Kleen wrote:
> On Sun, Sep 09, 2007 at 04:43:37PM +0200, Jiri Slaby wrote:
>> On 09/09/2007 04:33 PM, Andi Kleen wrote:
>>> On Sun, Sep 09, 2007 at 04:26:22PM +0200, Jiri Slaby wrote:
>>>> BTW it is reproducible for me on two different machines (i386-x86_64,
>>>> radeon-intel), don't you have the problem too?
>>> No problems here with a radeon, no.
>>>
>>> Does your CPU have clflush or not in /proc/cpuinfo?
>> BTW this is how my flush_kernel_map looks like:
> 
> Can you stick a printk into change_page_attr to log in which order
> it changes pages (including their addresses and the pgattr)? 

printk("%s: %p %p %.16lx %d\n", __func__, page, page_address(page),
pgprot_val(prot), numpages);
http://www.fi.muni.cz/~xslaby/sklad/panics/x-freeze_chpa.png

What other info needed?

-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
