Return-Path: <linux-kernel-owner+w=401wt.eu-S1753625AbZCIKAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbZCIKAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 06:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbZCIKAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 06:00:42 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:22566 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbZCIKAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 06:00:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gBxPEOmM1eBhykrw0b8LhB+Vbgpsd9tle6bi8fqZcWUqOZDVN5Tpscnefsg3kM8yW7
         T45rTL41j5Duql07td3t5s6a6mskWZ72+krUUEs2awyc6H5GAflr2dkodklRMP1kKjO+
         nce9dWK77JIhjMHSsAYWdf8ZoT2hHYTpiEL94=
MIME-Version: 1.0
In-Reply-To: <2d05c4580903090243k6cf73ee9ubb6c4fccf0f07a2f@mail.gmail.com>
References: <2d05c4580903090243k6cf73ee9ubb6c4fccf0f07a2f@mail.gmail.com>
Date: Mon, 9 Mar 2009 18:00:35 +0800
Message-ID: <df9815e70903090300v1f5077a9r18a9d343ae4f8687@mail.gmail.com>
Subject: Re: Linux* Processor Microcode Data File
From: Jike Song <albcamus@gmail.com>
To: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 9, 2009 at 5:43 PM, Dragoslav Zaric
<dragoslav.zaric.kd@gmail.com> wrote:
> Hello,
>
> I was browsing Intel web site for my processor docs and I bumped
> on download link "Linux* Processor Microcode Data File" and it says
> there:
>
> "The microcode data file contains the latest microcode definitions for
> all Intel processors.
> Intel releases microcode updates to correct processor behavior as
> documented in the respective
> processor specification updates. While the regular approach to getting
> this microcode update is via
> a BIOS upgrade, Intel realizes that this can be an administrative
> hassle. The Linux Operating System
> and VMware ESX products have a mechanism to update the microcode after
> booting. For example,
> this file will be used by the operating system mechanism if the file
> is placed in the /etc/firmware
> directory of the Linux system."
>
> So, does new kernel versions just copy this microcode update file in
> /etc/firmware folder or new
> instructions are replaced in assembly code ?
>

Linux provides an microcode driver for Intel & AMD CPUs:

    arch/x86/kernel/microcode_*

and there is a service called "microcode_ctl" to open it and write the
microcode on every starting.   Where to find the microcode data is
this service specified, and the kernel doesn't care it.  You may want
to find:

http://www.urbanmyth.org/microcode/

> new  instructions are replaced in assembly code ?
As far as I can tell, no.   The microcode only only change the CPU's
behavior, not the assembler.


-- 
Thanks,
Jike
