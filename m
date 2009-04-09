Return-Path: <linux-kernel-owner+w=401wt.eu-S937006AbZDIXEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937006AbZDIXEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 19:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbZDIXEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 19:04:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54164
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752692AbZDIXEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 19:04:38 -0400
Date: Thu, 09 Apr 2009 16:04:28 -0700 (PDT)
Message-Id: <20090409.160428.166729831.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: dvhltc@us.ibm.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/futexes] sparc64: extend TI_RESTART_BLOCK space by 8
 bytes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090410083209.03dbd756.sfr@canb.auug.org.au>
References: <tip-d2de688891909b148efe83a6fc9520a9cd6015f0@git.kernel.org>
	<49DE12DD.1040802@us.ibm.com>
	<20090410083209.03dbd756.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 10 Apr 2009 08:32:09 +1000

> Hi Darren,
> 
> On Thu, 09 Apr 2009 08:23:09 -0700 Darren Hart <dvhltc@us.ibm.com> wrote:
>>
>> Also, I noticed the following embedded in the definition of the 
>> structure, does enabling this option also break sparc64 builds?
>> 
>> #ifdef CONFIG_COMPAT
>> 			struct compat_timespec __user *compat_rmtp;
>> #endif
> 
> Sparc64 would always have CONFIG_COMPAT enabled.

I can be turned off, and people have done this who want to
run a 64-bit only system.
