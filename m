Return-Path: <linux-kernel-owner+w=401wt.eu-S1760238AbXHaFqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238AbXHaFqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 01:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbXHaFqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 01:46:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48749 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbXHaFpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 01:45:53 -0400
Message-ID: <46D7AAF7.1030105@zytor.com>
Date: Thu, 30 Aug 2007 22:45:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Will Simoneau <simoneau@ele.uri.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: new x86 setup code hangs on Dell Inspiron 5150
References: <20070831015620.GA6259@ele.uri.edu>
In-Reply-To: <20070831015620.GA6259@ele.uri.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Will Simoneau wrote:
> While trying to put together a new kernel for my laptop (Dell I5150, as
> in subject) I found that recent kernels just don't boot. Right after
> grub loads the kernel, before the "Uncompressing Linux" message is
> shown, it hangs. The BIOS appears to still be alive (ctrl-alt-del works,
> keyboard lock LEDs respond). It seems to be caused by the new x86 setup
> code.
> 
> My kernel is Linus' git as of a1c582d0720f2eff61043e90711767decf37b917.
> I bisected and confirmed that 4fd06960f120e02e9abc802a09f9511c400042a5
> triggers a non-functioning boot.
> 
> This system has Dell BIOS rev A38 and a P4 3.2 w/HT.
> 
> What should I do next to debug this problem?

Can you put in some printf's in the code and see how far it gets?

	-hpa
