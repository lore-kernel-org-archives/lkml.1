Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851Ab0ALJPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab0ALJPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 04:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509Ab0ALJPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 04:15:33 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:42050 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab0ALJPc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 04:15:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wsdSG8yOgRgOGbMsgj63dwgZdbll4rbQPs9mfYjv4g5O2HGQalhxk+Ikszj8Mm63D+
         X53yDU3e/dZtMUzJfF6Hp3VvcS+/+mR9r1ZFSm9/BAZQBMpcIAD5ZLqU5kSnMh3AnUVc
         hBGW5Ed0Lim1OSPa5ywVaU0wgldSNtUE4MEZo=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1001111906300.17145@localhost.localdomain>
References: <1263264483-3959-1-git-send-email-yinghai@kernel.org>
	 <1263264483-3959-4-git-send-email-yinghai@kernel.org>
	 <alpine.LFD.2.00.1001111906300.17145@localhost.localdomain>
Date: Tue, 12 Jan 2010 01:15:31 -0800
X-Google-Sender-Auth: 338d6b0e6b3c31cc
Message-ID: <86802c441001120115g44a0198fub708d85439ef09ec@mail.gmail.com>
Subject: Re: [RFC PATCH 2/4] x86: use dmi check to treat disabled cpus as 
	hotplug cpus.
From: Yinghai Lu <yinghai@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 7:13 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Mon, 11 Jan 2010, Yinghai Lu wrote:
>>
>> some systems that have disable cpus entries because same
>>   BIOS will support 2 sockets and 4 sockets and more at
>>   same time, BIOS just leave some disable entries, but
>>   those system do not support cpu hotplug. we don't need
>>   treat disabled_cpus as hotplug cpus.
>>
>> so we can make nr_cpu_ids smaller and save more space
>>   (pcpu data allocations), and could make some systems run
>>   with logical flat instead of physical flat apic mode
>
> .. but this one I detest.
>
> We can't play games that depend on us always filling in some DMI table
> correctly. Things need to "just work".

maybe could change to list that doesn't need to treat disabled cpus as
hotplug cpus?

YH
