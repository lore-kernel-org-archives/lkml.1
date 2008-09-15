Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbYIOQPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbYIOQPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 12:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbYIOQPC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 12:15:02 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:52857 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbYIOQPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 12:15:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UR/7EhHuOMItb4Ls62IYVgxzKWec/rbwvL8V1wN6Bny++q22fUMklft5BffQ8GFl3s
         f0PyZL2zTTj4zCyY6PFfHuIkNlMWeWUVk0HBQg20nnHRkiAzl8O8AXFXeC6UNbMr6ltB
         qNC+rVLy6aCJaNKmDaXVIpC0kjGnCued4447M=
Message-ID: <86802c440809150914w67891a0bwac8db1f6748827e8@mail.gmail.com>
Date: Mon, 15 Sep 2008 09:14:59 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: [PATCH] introduce boot_printk()
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080915095838.GB1861@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221465916-30889-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080915095838.GB1861@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2008 at 2:58 AM, Pavel Machek <pavel@suse.cz> wrote:
> On Mon 2008-09-15 01:05:16, Yinghai Lu wrote:
>> could be enabled via "boot=verbose" to get more debug info
>>
>> will use it to convert some printk(KERN_DEBUG ...)
>>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>
> boot= is a bit too generic name, I guess...

Ingo suggest to use x86=verbose

but some users are in driver/acpi etc

YH
