Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251Ab0AFHHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab0AFHHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 02:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656Ab0AFHHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 02:07:41 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:40018 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab0AFHHj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 02:07:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=s7EktRjErrvRD0ITTfUlyGuzYhck/WMPvHSvbJApYOAimO41FCoqI4jUA5ucXR3pu4
         jRilFDgLzrYAtEHg98FO4oXSqC+7r2W6ZlHsV7sewhFAGHGTKvCSN46FPir6tKEpoAip
         luJ4kGT7nqJmo45DbQTmJGslXTTeke96+AJyc=
MIME-Version: 1.0
In-Reply-To: <4B430457.5020906@kernel.org>
References: <daef60381001030705r93b3fbfkc50e7b9bbc62b334@mail.gmail.com> 
	<4B411F14.1040302@kernel.org> <20100103150134.5bdab023@infradead.org> 
	<4B412341.2010002@kernel.org> <20100103151406.20228c3a@infradead.org> 
	<daef60381001040822q188d7374te5a177c5f9877ac2@mail.gmail.com> 
	<4B4273D6.2010306@kernel.org> <daef60381001050104u5d4adf11k16bec2406501fbd2@mail.gmail.com> 
	<4B430457.5020906@kernel.org>
From: Hui Zhu <teawater@gmail.com>
Date: Wed, 6 Jan 2010 15:07:18 +0800
Message-ID: <daef60381001052307x3244442che26075e4a3e0d2f8@mail.gmail.com>
Subject: Re: [PATCH] stack2core: show stack message and convert it to core 
	file when kernel die
To: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Russell King <linux@arm.linux.org.uk>,
       saeed bishara <saeed.bishara@gmail.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Nicolas Pitre <nico@fluxnic.net>, Ralf Baechle <ralf@linux-mips.org>,
       David Daney <ddaney@caviumnetworks.com>,
       Tomaso Paoletti <tpaoletti@caviumnetworks.com>,
       Chris Dearman <chris@mips.com>,
       Paul Gortmaker <Paul.Gortmaker@windriver.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Brian Gerst <brgerst@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Coly Li <coly.li@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 5, 2010 at 17:20, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On 01/05/2010 06:04 PM, Hui Zhu wrote:
>> I agree with read the current stack message is better.
>>
>> About the extending, I have some question with it:
>> 1.  markup_oops.pl have itself idea, it try use dmesg| markup_oops.pl
>> show what happen to usr.  This is different with s2c.
>> I am not sure people like it have other function with it.  Too much
>> part of this file need to be change.  It need rewrite, just the oops
>> message parse part can be keep.
>
> Yeah, I think you'll need to refactor it and share only the parsing
> frontend.  Just adding a switch (-m or whatever) which puts it into
> machine-friendly translator mode should do the trick.
>
>> 2.  I use perl to work in a long time before, I know it good at parse
>> the text, but I am not sure it good at handle struct like:
>
> You don't need to handle the data structure at all.  Just make it
> parse the dmesg and output machine-friendly formatted output which can
> be processed by s2c.  ie. just make it do the reformatting.

This idea is very cool.  I will do it.  Thanks for help.  :)

Best regards,
Hui
