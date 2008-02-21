Return-Path: <linux-kernel-owner+w=401wt.eu-S934929AbYBUV1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934929AbYBUV1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 16:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762243AbYBUV1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 16:27:25 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:5701 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761311AbYBUV1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 16:27:23 -0500
X-Spam-Flag: NO
X-Spam-Score: -4.389
Message-ID: <47BDECAD.3020004@tremplin-utc.net>
Date: Thu, 21 Feb 2008 22:27:09 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.9) Gecko/20080214 Mandriva/2.0.0.9-8mdv2008.1 (2008.1) Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
Cc: Sergey Vlasov <vsu@altlinux.ru>, dsdt@gaugusch.at, len.brown@intel.com,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       trenn@suse.de
Subject: Re: [PATCH] Allow populate_rootfs() to be called early
References: <20080210071226.GA23360@lst.de> <20080210071454.GA23428@lst.de> <47AEE6D1.4070402@tremplin-utc.net> <20080211164719.d42c618e.vsu@altlinux.ru> <47B0DD34.4010604@tremplin-utc.net> <47BDCACC.2030302@tremplin-utc.net> <20080221190455.GA7275@lst.de>
In-Reply-To: <20080221190455.GA7275@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

21/02/08 20:04, Christoph Hellwig wrote/a écrit:
> On Thu, Feb 21, 2008 at 08:02:36PM +0100, Eric Piel wrote:
>> It's been a week and no one has screamed, so I guess the idea looks fine
>> to everyone :-) 
>>
>> Here is a boot tested patch for integration. In addition to the previous
>> version, it removes also rootfs_initcall(), and uses fs_initcall_sync().
>> There should be absolutely no difference in behaviour as there was no
>> user of fs_initcall_sync() in the kernel.
>>
>> I'm not sure what should be the best tree to go through. Maybe the ACPI
>> tree, as all this is needed for CONFIG_ACPI_CUSTOM_DSDT_INITRD...
> 
> Actually I've just got a report today where we get an uninitialized
> spinlock due to this in -mm.  It's probably possible to work around it,
> though.
What do you mean by "due to this"? Due to userspace helper being called
too early? Then this patch should fix the bug.

Eric
