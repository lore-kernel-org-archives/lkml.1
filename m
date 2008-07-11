Return-Path: <linux-kernel-owner+w=401wt.eu-S1757533AbYGKIjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbYGKIjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 04:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbYGKIjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 04:39:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:48016 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbYGKIjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 04:39:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HLw18+bymXKjs3A416PhanA888n8HO3iwjYbDgzlmWc1J/VhJQC4NHAzD6QY3G6jMh
         S+0jj6wsV1vpxQiLhlx5TtzDppKJKeM0Uj4qLgwaJunIr38wLa4NrdwRft5ZB2Z+myNs
         IAdv24SeLbRLMUrgR1qzuhyhD6AARruYzea0A=
Message-ID: <86802c440807110139x429cdc41wc95a208c5e000ee3@mail.gmail.com>
Date: Fri, 11 Jul 2008 01:39:04 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: introduce max_low_pfn_mapped for 64bit
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080711082601.GC4427@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807080141.05436.yhlu.kernel@gmail.com>
	 <200807092016.36490.yhlu.kernel@gmail.com>
	 <200807092017.51004.yhlu.kernel@gmail.com>
	 <200807102038.26591.yhlu.kernel@gmail.com>
	 <20080711082601.GC4427@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 1:26 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> when 4g more memory installed, don't map big hole below 4g.
>
> applied to tip/x86/core, thanks Yinghai.
>
> This is a scarier change - no way to do it in smaller steps?

1. e820_end ==> e820_end_of_ram_pfn :: totally safe...
2. others

YH
