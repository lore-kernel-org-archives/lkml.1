Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbZEWSFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbZEWSFI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 14:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbZEWSE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 14:04:57 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:47557 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbZEWSE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 14:04:57 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Sat, 23 May 2009 13:04:45 -0500
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
References: <200905221139.26941.lkml@morethan.org> <200905221946.01808.lkml@morethan.org> <4A1748A9.1020306@zytor.com>
In-Reply-To: <4A1748A9.1020306@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905231304.55973.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri May 22 2009, H. Peter Anvin wrote:
> Michael S. Zick wrote:
> > Same integrated motherboard.
> 
> Which means same CPU, same BIOS, same motherboard (none of which you're
> telling us.)
> 
> cpuinfo and dmidecode would be informative.
>

The -09143lk files are posted.

Download location:
http://hp-umpc.com/ce1200v

Details so far today:
http://forum.netbookuser.com/viewtopic.php?pid=6968#p6968

Summary:
HP-2133 (C7-M/CN896) - 09143 - No results - Still up 3 1/2 hours.
Cloudbook (C7-M/CX700) - 09143 - 45 minutes.
Cloudbook (C7-M/CX700) - 09143lk - No results - Still up 1 1/2 hours.

OK - time to look for the missing "memory" in the clobber lists.  ;)

Mike
 
> 	-hpa
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


