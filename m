Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbYFMSCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbYFMSCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 14:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbYFMSCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 14:02:03 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:11179 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbYFMSCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 14:02:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=U56i15H73MFF5eRG8v1BwAr6nt14KCSeItTh1cfgIKtzZCubggSh4bVE22p+tXvYX7
         AsJXUBYYs9VbNL5JwRmeamYPPpZnMIHrxMhwq5bX10D7EDRXSbLhd7ZLVl30c1bKM/tn
         neY4UvMIOiKMiXOQHyB8rdswT1/SLOxcWYyu0=
Message-ID: <86802c440806131102s44d4b909jadc21cec89d0cc11@mail.gmail.com>
Date: Fri, 13 Jun 2008 11:02:00 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: clean up reserve_bootmem_generic
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080613112256.GE9867@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806130200.56822.yhlu.kernel@gmail.com>
	 <20080613112256.GE9867@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 4:22 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> 1. add reserve_bootmem_generic for 32bit
>> 2. change len to unsigned long
>> 3. make early_res_to_bootmem to use it
>
> applied to tip/x86/mpparse - thanks Yinghai.
>
> This does properly finish my band-aid:
>
> # x86/mpparse: f245905: x86: unify the reserve_bootmem() behavior of early_res_to_bootmem()
>
> correct?

yes. restore the original behavior of that for 64bit.

YH
