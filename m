Return-Path: <linux-kernel-owner+w=401wt.eu-S933899AbXDAS7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933899AbXDAS7H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933903AbXDAS7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:59:07 -0400
Received: from smtpout.mac.com ([17.250.248.176]:52948 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933899AbXDAS7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:59:06 -0400
In-Reply-To: <460E0158.7090705@goop.org>
References: <460E0158.7090705@goop.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <8393D4C0-57C5-4CD2-8CA4-E4241E74FB4E@mac.com>
Cc: Andi Kleen <ak@suse.de>, "Brown, Len" <len.brown@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: 2.6.21-rc5: Thinkpad X60 gets critical thermal shutdowns
Date: Sun, 1 Apr 2007 14:57:57 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 31, 2007, at 02:36:08, Jeremy Fitzhardinge wrote:
> When I run 2.6.21-rc5 + Andi's x86 patches + paravirt_ops patches,  
> I've been getting my machine shut down with critical thermal  
> shutdown messages:
>
> Mar 30 23:19:03 localhost kernel: ACPI: Critical trip point
> Mar 30 23:19:03 localhost kernel: Critical temperature reached (128  
> C), shutting down.
> Mar 30 23:19:03 localhost kernel: Critical temperature reached (128  
> C), shutting down.
> Mar 30 23:19:03 localhost shutdown[19417]: shutting down for system  
> halt
>
> and the machine does feel pretty hot.  Interestingly, when the  
> machine reboots, the fan spins up to a noticeably higher speed, so  
> it seems that maybe something is getting fan speed control wrong.

Well, 128C is more than hot enough to boil water and well above the  
thermal tolerances of most CPUs, so I would imagine that were your  
CPU actually that hot it wouldn't be capable of printing the  
"Critical temperature reached" messages, let alone properly rebooting.

Cheers,
Kyle Moffett

