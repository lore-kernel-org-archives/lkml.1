Return-Path: <linux-kernel-owner+w=401wt.eu-S1762122AbYJJQUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762122AbYJJQUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 12:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759557AbYJJQUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 12:20:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:46551 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759575AbYJJQUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 12:20:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=l1WGKfWJ5keFTTUPnS6gbU+ccUy7Qh24q+4hXkSQGosOJEsiaQ7BJHwsLtNyyAQbg2
         iX+0J8qG8Qtm/LauooShueui4V7DeKUeGgdyHLtzMzaocjDZd4x8lta5z9tXsN/KKfPK
         r+0xRIPbc6mXbg3+lsWFmVn37z1sC8qShkpqI=
Message-ID: <86802c440810100920s5ce8e1acm54afc0e257b15235@mail.gmail.com>
Date: Fri, 10 Oct 2008 09:20:15 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] More informative about unknown CPU
Cc: "Hans Schou" <linux@schou.dk>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20081010150458.GG11695@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0810092014190.7473@sko.w0.dk>
	 <20081010150458.GG11695@elte.hu>
X-Google-Sender-Auth: b71efb424d237dfc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 8:04 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Hans Schou <linux@schou.dk> wrote:
>
>> Hi
>>
>> Write the name of the unknown vendor_id to output instead of just
>> "file not found".
>>
>> Tag changed to 'vendor_id' as used in /proc/cpuinfo
>>
>> Signed-off-by: Hans Schou <linux@schou.dk>
>
> applied to tip/x86/unify-cpu-detect, thanks Hans!
>
>> --- linux.trees.git/arch/x86/kernel/cpu/common.c.orig   2008-10-09 17:33:29.000000000 +0200
>> +++ linux.trees.git/arch/x86/kernel/cpu/common.c        2008-10-09 17:33:59.000000000 +0200
>> @@ -413,7 +413,7 @@ static void __cpuinit get_cpu_vendor(str
>>
>>         if (!printed) {
>>                 printed++;
>> -               printk(KERN_ERR "CPU: Vendor unknown, using generic init.\n");
>> +               printk(KERN_ERR "CPU: vendor_id '%s' unknown, using generic init.\n", v);
>>                 printk(KERN_ERR "CPU: Your system may be unstable.\n");
>
> btw., this was whitespace damaged (i fixed that up by hand). See
> Documentation/email-clients.txt about how to set up the email client.
> (or, when you send x86 patches, you can attach the patch as a MIME
> attachment)
>

What is unknown cpus?

>From Sis or Nvidia?

YH
