Return-Path: <linux-kernel-owner+w=401wt.eu-S1758273AbXIXSpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbXIXSpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 14:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760086AbXIXSp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 14:45:27 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:49345 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759997AbXIXSp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 14:45:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=DWQA0/xiEGsarI2ZczaIacafQulskSM9lFB7So9kATrrgV0HJA+EhPHMjF7UdNC3FoWmX8sFmTqnXLmvMcnh/Ksp3AciZwjg7d0kuZBfKgNToPaZJMqj6UmxQVB7iHRbGZzHd/khxxw9yFlNl+HS6GjMGaGwrvTnLwl8H9XCVdY=
Message-ID: <46F805BE.5090609@gmail.com>
Date: Mon, 24 Sep 2007 20:45:18 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] 2.6.23-rc7-mm1
References: <Pine.LNX.4.44L0.0709241039040.4256-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0709241039040.4256-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2007 04:41 PM, Alan Stern wrote:
> On Mon, 24 Sep 2007, Jiri Slaby wrote:
> 
>> On 09/24/2007 11:17 AM, Andrew Morton wrote:
>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc7/2.6.23-rc7-mm1/
>> Fine, but on some boots (I noticed this on rc6-mm1 too, but not before):
>> 0000:00:1a.7 EHCI: BIOS handoff failed (BIOS bug ?) 01010001
>> 0000:00:1d.7 EHCI: BIOS handoff failed (BIOS bug ?) 01010001
> 
> Any changes in your BIOS setup?

unlikely, but still possible -- I've made some changes in BIOS recently when I
looking backwards. Which concrete changes would turn it in such behaviour?

> What about with vanilla 2.6.23-rc6?  Or vanilla 2.6.23-rc7?
> 
> The USB part of the code here hasn't changed in quite a while.  Any 
> difference in behavior must be the result of changes in some other part 
> of the kernel.  Possibly ACPI.
> 
> This might be a good job for git-bisect.

Ok, I'll play with that little bit.

thanks,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
