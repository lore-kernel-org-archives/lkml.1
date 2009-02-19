Return-Path: <linux-kernel-owner+w=401wt.eu-S1757454AbZBSPmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbZBSPmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 10:42:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbZBSPlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 10:41:53 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:35998 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbZBSPlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 10:41:52 -0500
Message-ID: <499D7DA6.3060007@knaff.lu>
Date: Thu, 19 Feb 2009 16:41:26 +0100
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jan Engelhardt <jengelh@medozas.de>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: tip: bzip2/lzma now in tip:x86/setup-lzma
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu> <4961415C.1050708@zytor.com> <49614243.70102@knaff.lu> <496142E4.8040308@zytor.com> <49614491.7020903@knaff.lu> <49614D1F.8020900@zytor.com> <alpine.LSU.2.00.0902172202230.5620@fbirervta.pbzchgretzou.qr> <499B267E.2090509@zytor.com> <20090217220825.GA24337@elte.hu> <20090217233708.GA10756@elte.hu> <499B5BCA.8000905@zytor.com> <499BBD62.5090506@knaff.lu> <alpine.LSU.2.00.0902181012130.5116@fbirervta.pbzchgretzou.qr> <499BD795.6050602@knaff.lu> <alpine.LSU.2.00.0902181127310.30241@fbirervta.pbzchgretzou.qr> <499CF8D2.9080309@knaff.lu> <499D70CE.6050508@zytor.com>
In-Reply-To: <499D70CE.6050508@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Alain Knaff wrote:
>> Jan Engelhardt wrote:
>>> Even if it is true in general, I would not remove CONFIG_INITRAMFS_SOURCE
>> Hmmm, but now that I think of it, maybe the CONFIG_INITRAMFS_SOURCE
>> setting could be used to decide whether to compress initramfs.
>>
>> If empty => do not compress builtin initramfs. It's only 950 bytes, and
>> will be compressed along with the kernel anyways.
>>
>> If not empty => use an additional config setting (let's call it
>> CONFIG_INITRAMFS_COMPRESSION) to decide which compressor to use.
>>
> 
> No, that's at least potentially very wrong.  Let's not go down that rathole.
> 
> 	-hpa
> 

Could you please elaborate why you consider this so wrong?

Regards,

Alain

