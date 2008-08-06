Return-Path: <linux-kernel-owner+w=401wt.eu-S1760193AbYHFSvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760193AbYHFSvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 14:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755708AbYHFSuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 14:50:55 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:37324 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065AbYHFSuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 14:50:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uksdHGtdLh6XcmocRkHgXuVH9HjrQxH4GfOebKJEonGa20y2d8jpmuf3IMVd4jb0GO
         9KZC3td6ScB/gz08YxTKJuuWk8K8aFV+IEGWYKkB8Hk7LYfhW0epNnWB5TjKaVki3h5S
         oRhbjeMM3bz/H+n3CcEe/c2AeNZODzd+yKT+o=
Message-ID: <86802c440808061150h3ad31052j8aa5ccc4a54edb2d@mail.gmail.com>
Date: Wed, 6 Aug 2008 11:50:53 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 00/33] dyn_array and nr_irqs support v4
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <86802c440808061129l2bbe1658w453a11b4f16ffc83@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218011937-10084-1-git-send-email-yhlu.kernel@gmail.com>
	 <m1hc9yjb7x.fsf@frodo.ebiederm.org>
	 <86802c440808061129l2bbe1658w453a11b4f16ffc83@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> - Introduce get_irq_desc and the functions or function modifications
>>  that pass a struct irq_desc * into the genirq code.
>>
>>  Although I absolutely hate the name get_irq_desc as it implies we are
>>  reference counting something and need a corresponding put_irq_desc.
>>  Since the lifetime rules don't require that.  Please just call the
>>  function irq_desc().
>
> will check that.
>
how about get_irq_desc_without_new()?

irq_desc_without_new()

YH
