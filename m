Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbYIPVEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbYIPVEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 17:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbYIPVEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 17:04:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:19991 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbYIPVEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 17:04:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Uvgobhy6PeCDq1B5dAaC04EdQpF2mgaLe4WePZAnAwo/XVIVUuQNVwyiBJtCkeH5VD
         2Wm9R588r7U2tgGotivmdZo/L39QDXdB2DSAxzghwj+dFWUXtw8adrjkNCxsDuB4xYuy
         l8MJ/h+BDQApmUB9vmFKvKkhWGG4S8cyy+ZOk=
Message-ID: <86802c440809161404v4b59f1c8se1ac61f982a15dd@mail.gmail.com>
Date: Tue, 16 Sep 2008 14:04:33 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Marcin Slusarz" <marcin.slusarz@gmail.com>
Subject: Re: [PATCH 1/5] add DEFINE_LOGLEVEL_SETUP v3
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080916190224.GA6115@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221588085-30578-1-git-send-email-yhlu.kernel@gmail.com>
	 <1221588085-30578-2-git-send-email-yhlu.kernel@gmail.com>
	 <20080916190224.GA6115@joi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 12:02 PM, Marcin Slusarz
<marcin.slusarz@gmail.com> wrote:
> On Tue, Sep 16, 2008 at 11:01:21AM -0700, Yinghai Lu wrote:
>> --- linux-2.6.orig/include/linux/kernel.h
>> +++ linux-2.6/include/linux/kernel.h
>> @@ -104,6 +104,15 @@ extern int console_printk[];
>>  #define minimum_console_loglevel (console_printk[2])
>>  #define default_console_loglevel (console_printk[3])
>>
>> +#define      KERN_LOG_EMERG  0       /* system is unusable                   */
>> +#define      KERN_LOG_ALERT  1       /* action must be taken immediately     */
>> +#define      KERN_LOG_CRIT   2       /* critical conditions                  */
>> +#define      KERN_LOG_ERR    3       /* error conditions                     */
>> +#define      KERN_LOG_WARNING        4       /* warning conditions                   */
>> +#define      KERN_LOG_NOTICE 5       /* normal but significant condition     */
>> +#define      KERN_LOG_INFO   6       /* informational                        */
>> +#define      KERN_LOG_DEBUG  7       /* debug-level messages                 */
>> +
>>  struct completion;
>>  struct pt_regs;
>>  struct user;
>
> maybe
> #define KERN_LOG_EMERG 0,KERN_EMERG
> #define KERN_LOG_ALERT 1,KERN_ALERT
> ...
> ?
>
> or better - create printk2(level, fmt) which prints "<", level, ">", fmt
> and wrap it with pci_printk / acpi_printk?
>

will come out one new version that hpa likes

printk(KERN_PCI KERN_DEBUG "sadfasf\n");

YH
