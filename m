Return-Path: <linux-kernel-owner+w=401wt.eu-S933275AbZJLXri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275AbZJLXri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 19:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757408AbZJLXri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 19:47:38 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:45256 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754850AbZJLXrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 19:47:37 -0400
Message-ID: <4AD3BFD8.90408@snapgear.com>
Date: Tue, 13 Oct 2009 09:46:32 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tim Abbott <tabbott@ksplice.com>
CC: Greg Ungerer <gerg@uclinux.org>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v2 2/2] m68knommu: Clean up linker script using new linker
 script macros.
References: <1253638615-27009-1-git-send-email-tabbott@ksplice.com> <1253638615-27009-3-git-send-email-tabbott@ksplice.com> <4AC44477.8000703@snapgear.com> <alpine.DEB.1.10.0910010905340.5982@dr-wily.mit.edu>
In-Reply-To: <alpine.DEB.1.10.0910010905340.5982@dr-wily.mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

Tim Abbott wrote:
> On Thu, 1 Oct 2009, Greg Ungerer wrote:
>> Tim Abbott wrote:
>>> Signed-off-by: Tim Abbott <tabbott@ksplice.com>
>>> Cc: Greg Ungerer <gerg@uclinux.org>
>> This results in kernels that don't boot for me. I haven't done
>> any more debugging than to just try booting at this time.
> [...]
>> Does that look like what you would have expected?
> 
> Basically.  I'm a bit surprised that the .init_begin section doesn't show 
> up, but I'm pretty sure that this is because .init_begin would have had 
> size zero as the previous section's end was already page-aligned.
> 
>> I suspect the problem may lie in the binary conversion of this
>> elf file to a raw binary for booting. This uses objcopy with
>> "-O binary". The resulting binary files are different in size
>> with and without the patch by about 2582 bytes. Suspicious
>> me thinks.
> 
> I don't any good ideas for what in patch is likely to be responsible.  
> Would it be helpful to debug if I split this into ~5 very small patches so 
> that we can find out what part of the patch is responsible?

Yes, that will make it quick and easy for me.

Thanks
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
