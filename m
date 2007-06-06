Return-Path: <linux-kernel-owner+w=401wt.eu-S934899AbXFFSLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934899AbXFFSLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 14:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757135AbXFFSLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 14:11:40 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:36061 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464AbXFFSLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 14:11:40 -0400
Date: Wed, 06 Jun 2007 11:11:44 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: 2.6.22-rc4-mm1 -- ia64 build failure
In-reply-to: <20070606104358.fbafc08b.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <4666F8E0.8030501@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=US-ASCII
Content-transfer-encoding: 7BIT
References: <20070606020737.4663d686.akpm@linux-foundation.org>
 <4666BB65.8050800@shadowen.org>
 <20070606104358.fbafc08b.akpm@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 06 Jun 2007 14:49:25 +0100 Andy Whitcroft <apw@shadowen.org> wrote:
> 
>> Seeing this on an ia64:
>>
>> drivers/built-in.o: In function `efi_setup_pcdp_console':
>> (.init.text+0x13be2): undefined reference to `early_serial_console_init'
>> drivers/built-in.o: In function `efi_setup_pcdp_console':
>> (.init.text+0x13de2): undefined reference to `early_serial_console_init'
>> make: *** [.tmp_vmlinux1] Error 1
> 
> We really exceeded ourselves this time.  .config, please?

Oh, i miss that file. will submit the patch.

YH
