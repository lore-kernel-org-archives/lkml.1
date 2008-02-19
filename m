Return-Path: <linux-kernel-owner+w=401wt.eu-S1759621AbYBSWQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621AbYBSWQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762613AbYBSWO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:14:27 -0500
Received: from host64.cybernetics.com ([70.169.137.4]:4093 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755070AbYBSWOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:14:25 -0500
Message-ID: <47BB54C2.6090501@cybernetics.com>
Date: Tue, 19 Feb 2008 17:14:26 -0500
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Michael Chan <mchan@broadcom.com>
Cc: David Miller <davem@davemloft.net>, herbert@gondor.apana.org.au,
       netdev <netdev@vger.kernel.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: TG3 network data corruption regression 2.6.24/2.6.23.4
References: <47BA0984.2070306@cybernetics.com> <1203381120.13495.78.camel@dell> <20080218.163554.74130592.davem@davemloft.net> <1203383046.13495.87.camel@dell> <47BB00EC.3010607@cybernetics.com> <1203448265.13495.95.camel@dell>
In-Reply-To: <1203448265.13495.95.camel@dell>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Chan wrote:
> On Tue, 2008-02-19 at 11:16 -0500, Tony Battersby wrote:
>   
>> iSCSI
>> performance drops to 6 - 15 MB/s when the 3Com NIC is doing heavy rx
>> with light tx,
>>     
>
> That's strange.  The patch should only affect TX performance slightly
> since we are just turning off SG for TX.  Please take an ethereal trace
> to see what's happening and compare with a good trace.
>
>   

Update: when I revert Herbert's patch in addition to applying your
patch, the iSCSI performance goes back up to 115 MB/s again in both
directions.  So it looks like turning off SG for TX didn't itself cause
the performance drop, but rather that the performance drop is just
another manifestation of whatever bug is causing the data corruption.

I do not regularly use wireshark or look at network packet dumps, so I
am not really sure what to look for.  Given the above information, do
you still believe that there is value in examining the packet dump?

Tony

