Return-Path: <linux-kernel-owner+w=401wt.eu-S1760855AbZKZQqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760855AbZKZQqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:46:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760839AbZKZQqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:46:01 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:11328 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760797AbZKZQqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:46:00 -0500
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4B0EB0CB.9050006@tudelft.nl>
Date: Thu, 26 Nov 2009 17:46:03 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <E.A.B.Piel@tudelft.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091009 Mandriva/2.0.0.23-3mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>, mchehab@redhat.com,
       linux-kernel@vger.kernel.org, Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH] Edwin =?UTF-8?B?VMO2csO2ayBmb3VuZCB0aGUgZm9sbG93aW5n?=
 =?UTF-8?B?LCBzbyBmaXggaXQ=?=
References: <20091126152154.18281.24788.stgit@localhost.localdomain>
In-Reply-To: <20091126152154.18281.24788.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 26-11-09 16:22, Alan Cox schreef:
> In function ‘memset’,
> inlined from ‘ir_input_init’ at drivers/media/common/ir-functions.c:67:
> /home/edwin/builds/linux-2.6/arch/x86/include/asm/string_64.h:61:
> warning: call to ‘__warn_memset_zero_len’ declared with attribute
> warning: memset used with constant zero length parameter; this could be
> due to transposed parameters
> memset(ir->ir_codes, sizeof(ir->ir_codes), 0);
Hello,
A "grep -E "memset.*,.*, 0\\)" -r" also reports
drivers/staging/hv/StorVsc.c as a suspect:
memset(request, sizeof(struct storvsc_request_extension), 0);
memset(vstorPacket, sizeof(struct vstor_packet), 0);
memset(vstorPacket, sizeof(struct vstor_packet), 0);
memset(vstorPacket, sizeof(struct vstor_packet), 0);

Maybe someone cares about fixing it too?

Cheers,
Eric
