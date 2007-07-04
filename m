Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbXGDBhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbXGDBhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 21:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbXGDBhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 21:37:35 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:58717 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbXGDBhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 21:37:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=UrH6khVckNdVCA+qJCLEYUB8UNfNek7L2xoE638eXdwbcRRE+AiVLRn6ZVO3FNXxiva0KfLnN7DMYuT5dsYjfeknmffBZWNapQrrehwNv0hO0QRm/9+ZXao43gcqEbN9zaAxUG8flYNc81bolfz4SkN5jMRGSdB9Py1khroiMxU=
Message-ID: <468AF9D9.4060609@gmail.com>
Date: Wed, 04 Jul 2007 10:37:29 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Peter Osterlund <petero2@telia.com>
CC: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, hch@infradead.org
Subject: Re: PKTCDVD related bugzilla bugs
References: <46889817.4050007@gmail.com> <Pine.LNX.4.64.0707031111320.7564@r3000.localdomain>
In-Reply-To: <Pine.LNX.4.64.0707031111320.7564@r3000.localdomain>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

Peter Osterlund wrote:
> On Mon, 2 Jul 2007, Tejun Heo wrote:
> 
>> Hello, it's me again.
>>
>> We have another bug which reportedly is related to pktcdvd.  Please
>> respond.
>>
>> http://bugzilla.kernel.org/show_bug.cgi?id=7547
>> http://bugzilla.kernel.org/show_bug.cgi?id=7805
> 
> The problem is that when you run pktsetup, the driver will open the
> cdrom device and keep it open. A very long time ago, the driver didn't
> do that, but that caused other problems, see for example:
> 
>     http://herbie.ucs.indiana.edu/hypermail/linux/kernel/0407.0/0761.html
> 
> I don't know how to fix these problems in the kernel, but I know that an
> old idea from Jens Axboe was to merge pktsetup and mount in user space
> so that pktsetup only needs to run when you are actually going to use
> packet writing.

In bug 7547[1], somebody is issuing START_STOP to the ODD repeatedly
which times out if the drive is empty.  Is this coming from PKTCDVD or
from userland polling?  Also, do you mind adding yourself to the bug so
that I don't have to relay?

Thanks.

-- 
tejun

[1] http://bugzilla.kernel.org/show_bug.cgi?id=7547
