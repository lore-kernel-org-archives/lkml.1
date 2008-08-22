Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbYHVTUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbYHVTUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 15:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbYHVTUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 15:20:07 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:41755 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbYHVTUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 15:20:06 -0400
Message-ID: <48AF0FF5.1020007@oracle.com>
Date: Fri, 22 Aug 2008 12:13:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] documentation: add more early_param boot options
References: <48AF0D4E.2030007@oracle.com> <86802c440808221207k726a7eb5p67e2333818fe4303@mail.gmail.com>
In-Reply-To: <86802c440808221207k726a7eb5p67e2333818fe4303@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Fri, Aug 22, 2008 at 12:02 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Add some (more) early_param boot options to kernel-parameters.txt.
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> ---
>>  Documentation/kernel-parameters.txt |   12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> --- lin2627-rc4.orig/Documentation/kernel-parameters.txt
>> +++ lin2627-rc4/Documentation/kernel-parameters.txt
>> @@ -129,6 +129,13 @@ and is between 256 and 4096 characters.
>>  ./include/asm/setup.h as COMMAND_LINE_SIZE.
>>
>>
>> +       additional_cpus=  [IA-64,X86-32,X86-64]
>> +                       Format: <int>
>> +                       Specify the number of additional hotplug CPUs that
>> +                       should be supported/allowed.  Can be used to
>> +                       override BIOS info or to provide this info if not
>> +                       already available.
>> +
> how about the one in Documentation/x86/x86_64/boot-options.txt ?

Oh.  Thanks.  I'll think about how to handle that (or drop that part)
and respin/resend it.

