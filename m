Return-Path: <linux-kernel-owner+w=401wt.eu-S1758261AbYHDCL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261AbYHDCL2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 22:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbYHDCLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 22:11:20 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:40646 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbYHDCLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 22:11:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RzyHTdlJGoOJdAlQqI9Rnz9ti3AI1+IU/JPerDNxpate7f8uiH2GwP5REE3rsYuz9q
         MoLp3oXAxPfJIChN3GsHdj5+s5bj2sp3CpPwLUbGSNTYQAY/qYADrrpijAOttu2J0IEL
         DmZjogGFtGjP3Ao83zNbbWVQa2cqdNLFvTx/o=
Message-ID: <d82e647a0808031911j20cc9588o813bb15a46df1db4@mail.gmail.com>
Date: Mon, 4 Aug 2008 10:11:17 +0800
From: "Ming Lei" <tom.leiming@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [RFC] ftrace: support tracing functions in one module
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Steven Rostedt" <srostedt@redhat.com>
In-Reply-To: <alpine.DEB.1.10.0808031042440.30870@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d82e647a0808030050n3b72d96dh91c0ac94eadc34f@mail.gmail.com>
	 <alpine.DEB.1.10.0808031042440.30870@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/3 Steven Rostedt <rostedt@goodmis.org>:
>
> On Sun, 3 Aug 2008, Ming Lei wrote:
>
>> Hi,
>>
>> IMO, ftrace is a very good tools, which can monitor almost all
>> functions calling
>> in the running kernel. The traced result is very complete and intact.
>> But it seems
>> too large to grasp the interested content.  For example, one may only
>> have interest in
>> functions calling in usbcore.ko, but he must trace all the functions
>> calling in the
>> kernel, so the tracing result is too large to use it.
>>
>> Could you add the support of tracing functions in one module only to ftrace?
>
> Look at the set_ftrace_filter in ftrace.txt. You can pick and choose which
> functions to trace.  All the functions that can be traced is in

It seems not ver easy to opearte to trace all functions in a module. You need to
write all function names to set_ftrace_filter. Also some functions have
same names in kernel and modules. This can lead to some messed trace result.

Do you have the plan to support tracing functions in one module or in one kernel
address range?

> available_filter_functions in the debugfs/tracing directory.
>
> Note, the functions must execute at least once before they can be
> recorded.
>
> -- Steve
>
>



-- 
Lei Ming
