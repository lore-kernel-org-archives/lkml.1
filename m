Return-Path: <linux-kernel-owner+w=401wt.eu-S1764886AbZFORrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764886AbZFORrD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 13:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763743AbZFORqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 13:46:52 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:54822 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbZFORqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 13:46:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=WbFjlutfLCfySS/P26Ax2H6N9TcRzZtfLvWnYl5A+NHE/iaM91V23sT3L8eVJVSZeD
         MFULkxxtRjSWl5rbjUNndQKQDzmD4vsptC1IE8k0fA+PU3aMmRBILM4Go2WyTE6lnSjG
         2NaG4vUOsGmg2rMVzTAGn7Hr/2FmFvAa7MZaY=
Message-ID: <4A36881E.8010009@gmail.com>
Date: Mon, 15 Jun 2009 19:42:54 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Bryan Henderson <hbryan@us.ibm.com>
CC: Artem Bityutskiy <dedekind1@gmail.com>,
       Daniel Walker <dwalker@soe.ucsc.edu>,
       Jamie Lokier <jamie@shareable.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
References: <OFD1325B2C.7A926EF9-ON882575D6.00567314-882575D6.00571BC3@us.ibm.com>
In-Reply-To: <OFD1325B2C.7A926EF9-ON882575D6.00567314-882575D6.00571BC3@us.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Henderson wrote:
>> Marco wrote:
>>>    To enable direct
>>>    I/O at all times for all regular files requires either that
>>>    applications be modified to include the O_DIRECT flag on all file
>>>    opens, or that a new filesystem be used that always performs direct
>>>    I/O by default."
>> This could be done as well by just introducing a "direct_io_only"
>> mount option to a file-system which would need this feature.
> 
> But it's possible that there's just no advantage to having a block device 
> in the stack here.  When unix block devices were invented, their main 
> purpose was that they could reorder reads and writes and do buffering and 
> caching -- all things essential for disk drives.  We don't want to stretch 
> the concept too far.
> 

Yes I agree, we can't in this case talk about read and write reordering,
buffering and caching because we're talking about something completely
different from a classic disk. The issues of this kind of fs are more
similar to the tmpfs issues.

Marco
