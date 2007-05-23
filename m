Return-Path: <linux-kernel-owner+w=401wt.eu-S935445AbXEWTlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935445AbXEWTlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 15:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758343AbXEWTlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 15:41:08 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:35602 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758065AbXEWTlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 15:41:05 -0400
Message-ID: <46549825.6040500@gmail.com>
Date: Wed, 23 May 2007 21:38:13 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] CDROM: replace jiffies busyloop with msleep
References: <1179829525.12708.118.camel@chaos>	<46548ADB.60207@gmail.com> <20070523203436.01a005b0@the-village.bc.nu>
In-Reply-To: <20070523203436.01a005b0@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2007 09:34 PM, Alan Cox wrote:

>> driver was snappy in that regard. When I replaced our sleeping loop with a 
>> busy-wait same as the original the snappyness returned and moreover, reading 
>> the TOC from the CD went from something close to a minute to approximately a 
>> second. Thought that minute was just because I was dealing with an old junk 
>> 1-speed drive...
> 
> It happens. If you want to be fairer you can check need_resched in the
> loop so that you still share the CPU fairly with other users.

Thanks for the tip -- I'll do this.

Rene.

