Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbYEZWht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbYEZWht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 18:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253AbYEZWhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 18:37:39 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:60843 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236AbYEZWhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 18:37:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=mPypujKM2DLMKmG1xGGfGQd+94NzT7o61BQZZAgnVh0dhx3xJpbSMMoeMyJLwN5gs5o3XtPpEzsyUCBdTMVtywTjaiDwN6WlwFM9+6YBjKy5cBvmrs2j43z63o9HHpv16nbJCVMqH0S0zLXN3tzJsVekREHlR7RkiyhW4dE6BNY=
Message-ID: <483B3B7C.1000306@gmail.com>
Date: Tue, 27 May 2008 00:36:44 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "Noel (Sourceforge)" <noelb@users.sourceforge.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Serial error
References: <1211836442.5745.1.camel@roswell.ausics.net>
In-Reply-To: <1211836442.5745.1.camel@roswell.ausics.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2008 11:14 PM, Noel (Sourceforge) wrote:
> serial comms error with smsclient  >2.6.25 , worked fine up until and
> including 2.6.24.7
[...]
> 01:0c.0 Serial controller: PLX Technology, Inc. PCI <-> IOBus Bridge
> (rev 01) (prog-if 00 [8250])
>         Subsystem: Stallion Technologies, Inc. Unknown device f010

Do you have some patched driver or whatever, that this binds?

[...]
> Stallion Multiport Serial Driver: version 5.6.0
> Stallion Intelligent Multiport Serial Driver: version 5.6.0
> 0000:01:0c.0: ttyS4 at I/O 0xd880 (irq = 6) is a ST16654
> 0000:01:0c.0: ttyS5 at I/O 0xd888 (irq = 6) is a ST16654
> 0000:01:0c.0: ttyS6 at I/O 0xd890 (irq = 6) is a ST16654
> 0000:01:0c.0: ttyS7 at I/O 0xd898 (irq = 6) is a ST16654
> 0000:01:0c.0: ttyS8 at I/O 0xd8a0 (irq = 6) is a ST16654
> 0000:01:0c.0: ttyS9 at I/O 0xd8a8 (irq = 6) is a ST16654
> 0000:01:0c.0: ttyS10 at I/O 0xd8b0 (irq = 6) is a ST16654
> 0000:01:0c.0: ttyS11 at I/O 0xd8b8 (irq = 6) is a ST16654 <-- phone line
> in this port
> 
> 
> suggestions or assistance appreciated.

The only significant change is
ccfea3c98a10b9d4d49b899616a06594ec976d7d
could you try to revert it and re-test?
