Return-Path: <linux-kernel-owner+w=401wt.eu-S932794AbZDBACZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbZDBACZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 20:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758103AbZDBACQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 20:02:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59283 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbZDBACQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 20:02:16 -0400
Message-ID: <49D4007B.2090001@zytor.com>
Date: Wed, 01 Apr 2009 17:02:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Andreas Robinson <andr345@gmail.com>, Alain Knaff <alain@knaff.lu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] lib: add fast lzo decompressor
References: <1238593252-3435-1-git-send-email-andr345@gmail.com>	 <1238593252-3435-2-git-send-email-andr345@gmail.com>	 <49D3927A.2050406@zytor.com> <1238613730.10514.35.camel@andreas-desktop>	 <49D3D4C0.1080506@zytor.com> <1238624827.15230.58.camel@andreas-desktop> <49D3EDEA.4090803@zytor.com> <49D3F4A3.1040609@linux.intel.com>
In-Reply-To: <49D3F4A3.1040609@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>>
>> [Cc: Arjan, fast boot evangelizer. ;)]
> 
> as long as LZO is optional.... and it's documented somewhere to not use
> it if you want fast speed I'm totally fine.

LZO is the fastest (and least dense) decompression method on the 
spectrum, so I figured you'd care about it.  It's faster than gzip, for 
example.  (Of course, if you're loading-time-bound you might be better 
off using LZMA.)

	-hpa
