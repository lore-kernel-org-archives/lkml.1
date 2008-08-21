Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbYHUXt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbYHUXt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 19:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYHUXtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 19:49:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:40565 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbYHUXtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 19:49:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=w4N8Z1ydU0ESkwwJ9/n+op82p36WNseKTa+xJd5cQuoEoJ55v+ZCfMjOmGYsJU1yAV
         8A89jR+Dablz4mks4vgWAxVh0YtEPjBU7gYbqo7R0o1dJFWeBEyH0gWGpzoSkhtvuYdR
         XmQskkwhsaDfbMUM/pxLAdO8EGJMTHlMRONSU=
Message-ID: <86802c440808211649h37ac7533q4b95a83306ecd430@mail.gmail.com>
Date: Thu, 21 Aug 2008 16:49:17 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] x86: fix probe_nr_irqs for xen
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Alex Nixon" <alex.nixon@citrix.com>
In-Reply-To: <48ADFB33.8010204@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219349409-15698-1-git-send-email-yhlu.kernel@gmail.com>
	 <48ADFB33.8010204@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 4:33 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Yinghai Lu wrote:
>> otherwise Xen is _completely_ unusable with 5 or more VCPUs.
>> ( when !CONFIG_HAVE_SPARSE_IRQ)
>>
>> based on Alex's patch
>>
>> also add +1 offset after redir_entries
>>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>> Cc: Alex Nixon <alex.nixon@citrix.com>
>>
>
> Looks good to me.  We can fix this in a better way later.

later could set CONFIG_HAVE_SPARSE_IRQ to true by default.

YH
