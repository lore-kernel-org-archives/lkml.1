Return-Path: <linux-kernel-owner+w=401wt.eu-S1760839AbYFLXSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760839AbYFLXSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 19:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756734AbYFLXSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 19:18:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:28741 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816AbYFLXSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 19:18:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uDJ6zakI9v86mZNS1QH6+CHzr2k4DYchYU63M4kMMiVW/a1ar1ez02bXU0FX7pRhW/
         0Ux0l0uuZYBVNPGNTwTMb8z36WKoXZgmDHN+33o8FvOckoa1CEjJ9+iYhLjSC0jALPpC
         romi+v8/X9ZMjskzpvPP9RdNabHFgRNehRUuk=
Message-ID: <86802c440806121618t244e3088pdf93618209b9855e@mail.gmail.com>
Date: Thu, 12 Jun 2008 16:18:09 -0700
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

the same. it checks earlycon=uart and console=uart...

YH
