Return-Path: <linux-kernel-owner+w=401wt.eu-S1761238AbYFLXUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761238AbYFLXUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 19:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756368AbYFLXUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 19:20:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:29530 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576AbYFLXT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 19:19:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VU29wsF5qG7ETagda8BWZ8uG4hG0W4gMV2QQrg/ozxDTeNn0uUey6xXQwV+FgslL2o
         uAXtIpvQODtU7MwRW5NZihcWXJcExV5vJ7o7bFSe3+MisSgqng6o9CDknk0W6X8qs4hF
         +zxepGk2g8k5VrGEfaoPsgOiHl0/SfcMt+aE8=
Message-ID: <86802c440806121619g162626edv648b67b837e0d7f8@mail.gmail.com>
Date: Thu, 12 Jun 2008 16:19:59 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] x86: Add config option to setup early serial console
Cc: "Mike Travis" <travis@sgi.com>, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080612161049.3bb2f1a3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080612223802.528617000@polaris-admin.engr.sgi.com>
	 <20080612223802.673729000@polaris-admin.engr.sgi.com>
	 <20080612154600.fac8cc6b.akpm@linux-foundation.org>
	 <4851AA00.1050006@sgi.com>
	 <20080612161049.3bb2f1a3.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 4:10 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 12 Jun 2008 15:58:08 -0700
> Mike Travis <travis@sgi.com> wrote:
>
>> Andrew Morton wrote:
>> > On Thu, 12 Jun 2008 15:38:03 -0700
>> > Mike Travis <travis@sgi.com> wrote:
>> >
>> >>  * Add config option EARLY_SERIAL_CONSOLE to enable early
>> >>    printk's to be directed to the serial console.
>> ...
>> >>
>> >
>> > Confused.  What's wrong with console=uart,...?
>> >
>>
>> The problem is that I need the output really, really early before
>> the console is initialized.
>
> Sorry, I meant earlycon=uart..
> --

could move the parsing from early_param to head_64.c::x86_64_start_kernel

YH
