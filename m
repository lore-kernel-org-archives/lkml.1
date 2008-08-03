Return-Path: <linux-kernel-owner+w=401wt.eu-S1757890AbYHCRny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890AbYHCRny (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 13:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYHCRnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 13:43:46 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:63031 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbYHCRnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 13:43:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lE9n04cjVwh5JOQqArOBv+0qb06X1E1B7lExlmQvMVEL2mYa3IYf/ftQwxbroiQtpX
         MdORieR7XaAN47xjXfCCaRhETuo5orUpvdrJBZX0J/qs2UkW9U+hfqer5pVA8zySQhjX
         7FICq2k48uY5sF+6CjXK/6AvhvrXlt3H7HVfQ=
Message-ID: <86802c440808031043i1c0605c8wb5ba46b032397bbe@mail.gmail.com>
Date: Sun, 3 Aug 2008 10:43:44 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 15/25] drivers/serial to use nr_irqs
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080803140205.6c8d6090@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
	 <1217732365-16595-9-git-send-email-yhlu.kernel@gmail.com>
	 <1217732365-16595-10-git-send-email-yhlu.kernel@gmail.com>
	 <1217732365-16595-11-git-send-email-yhlu.kernel@gmail.com>
	 <1217732365-16595-12-git-send-email-yhlu.kernel@gmail.com>
	 <1217732365-16595-13-git-send-email-yhlu.kernel@gmail.com>
	 <1217732365-16595-14-git-send-email-yhlu.kernel@gmail.com>
	 <1217732365-16595-15-git-send-email-yhlu.kernel@gmail.com>
	 <1217732365-16595-16-git-send-email-yhlu.kernel@gmail.com>
	 <20080803140205.6c8d6090@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 3, 2008 at 6:02 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> -     for (i = 0; i < NR_IRQS; i++)
>> +     for (i = 0; i < nr_irqs; i++)
>>               spin_lock_init(&irq_lists[i].lock);
>>
>
> Don't you need to change how the array is allocated too ?

this one is applied before removing NR_IRQS usage in array definition.

YH
