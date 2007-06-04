Return-Path: <linux-kernel-owner+w=401wt.eu-S1761416AbXFDWwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761416AbXFDWwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757826AbXFDWwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:52:42 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:51634 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757392AbXFDWwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:52:41 -0400
Message-ID: <466496FA.4070508@gmail.com>
Date: Tue, 05 Jun 2007 00:49:30 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Q] Bio traversal trouble?
References: <4663DE68.5030200@gmail.com> <84144f020706041141q26d0cba2u352c294d1ec90daf@mail.gmail.com> <4664785C.4090205@gmail.com>
In-Reply-To: <4664785C.4090205@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2007 10:38 PM, Rene Herman wrote:

> On 06/04/2007 08:41 PM, Pekka Enberg wrote:
> 
> [ Jens' email address updated to his oracle address ]
> 
>> We can see that we're reading 2048 bytes from port 0x300 and storing
>> the data in memory location 0x8c1d2071 which causes the OOPS. What's
>> surprising is that EBP is set to 0x8c1d2071 too which suggests stack
>> corruption (note that ioread8_rep() is a fastcall so it does not
>> create a stack frame of its own). What you could do here is add some
>> printks and watch how dst changes over time to see if you can figure
>> out a pattern.
> 
> Mmm, I do always run with 4K stacks, I guess I'll try that next.

Nope, still there with 8K stacks and not harder to trigger.

Rene.
