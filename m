Return-Path: <linux-kernel-owner+w=401wt.eu-S1752388AbZIWR54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbZIWR54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 13:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbZIWR5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 13:57:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:51877 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbZIWR5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 13:57:54 -0400
Message-ID: <4ABA6182.1000106@windriver.com>
Date: Wed, 23 Sep 2009 12:57:22 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [origin tree boot hang] [PATCH] Revert "early_printk: Allow morethan
 one early console"
References: <20090923135539.GA6542@kroah.com> <20090923173709.GA18056@elte.hu>
In-Reply-To: <20090923173709.GA18056@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Sep 2009 17:57:34.0769 (UTC) FILETIME=[545DD210:01CA3C77]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>       early_printk: Allow more than one early console
>>     
>
> this patch broke things pretty badly on x86, with pretty much any 
> config, as long as the early console is used - which most of my 
> test-systems do :-(
>   

Ingo,

Can you send me the boot args and kernel config you are using?  I'd like
to figure out which part was at fault and fix it up.

Thanks,
Jason.
