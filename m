Return-Path: <linux-kernel-owner+w=401wt.eu-S1758587AbYEWR5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587AbYEWR5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 13:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbYEWR5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 13:57:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:31555 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbYEWR5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 13:57:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eJOETbteWu5sLTbn9fYhmVpMS/fp109cl6JNi/wOi8cOUyMAR0F9jDY8Z0evZnJBDHtOp8MbCZr1XpARpLPcu/gyjPXHijBP/xvymG3leUWAlo07iTK60SyuaQl96vhjASHzIMoa6pB2dG531AYZxRtsCI35HNPXdfQGC26qVfM=
Message-ID: <86802c440805231057v659e5c7ahfd0407d46ef34bfd@mail.gmail.com>
Date: Fri, 23 May 2008 10:57:22 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Robert Richter" <robert.richter@amd.com>
Subject: Re: Enable mmconf access to PCI ECS for all AMD fam10h systems
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <20080523124622.GV27511@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080523124622.GV27511@erda.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 5:46 AM, Robert Richter <robert.richter@amd.com> wrote:
> Yinghai,
>
> We would like to enable ECS for all fam10h systems. What was the
> reason for patch 5f0b2976 that enables it for Sun systems only? If
> there are no objections, this patch should be reverted.

Someone express the concern about touching MSR. Arjan or Andi?

for those of system that doesn't have MCFG table there, they could use
pci=check_enable_amd_mmconf to enable it forcely.

YH

>
> Thomas,
>
> is there a chance to revert the patch for 2.6.26?
>
> Thanks,
>
> -Robert
>
> --
> Advanced Micro Devices, Inc.
> Operating System Research Center
> email: robert.richter@amd.com
>
>
