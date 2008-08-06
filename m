Return-Path: <linux-kernel-owner+w=401wt.eu-S1422811AbYHFUxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422811AbYHFUxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbYHFUwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:52:54 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:54280 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351AbYHFUwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:52:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GsA1pFgJ1ItEp2nKWr97UdjcFjFq6J7CZZDv0/8UJ3oQKOj4qopye2yQWpZYDviqZt
         LLoSEwE3CvEfW9fPW7gZmCoEOOZW5/968S98XA2bJ5t5ekdTD6ze+0y7JY9ggJaWmP5n
         AzXO2MPvkR+oOBoP/mAwgqL6zGhu3Imgc2ynQ=
Message-ID: <86802c440808061352o693eccd5ge12e3e1c8698e022@mail.gmail.com>
Date: Wed, 6 Aug 2008 13:52:52 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 00/33] dyn_array and nr_irqs support v4
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m17iatkhou.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218011937-10084-1-git-send-email-yhlu.kernel@gmail.com>
	 <m1hc9yjb7x.fsf@frodo.ebiederm.org>
	 <86802c440808061129l2bbe1658w453a11b4f16ffc83@mail.gmail.com>
	 <86802c440808061150h3ad31052j8aa5ccc4a54edb2d@mail.gmail.com>
	 <m17iatkhou.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2008 at 1:32 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>
>>>>
>>>> - Introduce get_irq_desc and the functions or function modifications
>>>>  that pass a struct irq_desc * into the genirq code.
>>>>
>>>>  Although I absolutely hate the name get_irq_desc as it implies we are
>>>>  reference counting something and need a corresponding put_irq_desc.
>>>>  Since the lifetime rules don't require that.  Please just call the
>>>>  function irq_desc().
>>>
>>> will check that.
>>>
>> how about get_irq_desc_without_new()?
>>
>> irq_desc_without_new()
>
> Possibly irq_desc_with_new() or even create_irq_desc in the one or two code paths that care.
> Everywhere else can reasonably assume that the irq_desc entries have either been setup, or that
> the irq number is invalid.

will use irq_desc_with_new() toghether irq_desc()

YH
