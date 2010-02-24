Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758354Ab0BXWLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 17:11:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:49291 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758309Ab0BXWLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 17:11:19 -0500
Message-ID: <4B85A3C1.3030903@kernel.org>
Date: Wed, 24 Feb 2010 14:10:09 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Du, Alek" <alek.du@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] x86/pci: exclude mrst pci code for other platform
References: <43F901BD926A4E43B106BF17856F07559FB80D01@orsmsx508.amr.corp.intel.com> <tip-d39f6495f66616b637260405d0b5dc2656bc490e@git.kernel.org> <4B8493A0.6080501@kernel.org> <4B84A846.1000805@kernel.org> <4B84AAC4.2020204@kernel.org> <4B858E89.7040807@kernel.org> <43F901BD926A4E43B106BF17856F0755A321EB54@orsmsx508.amr.corp.intel.com> <4B859DD1.601@zytor.com>
In-Reply-To: <4B859DD1.601@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2010 01:44 PM, H. Peter Anvin wrote:
> On 02/24/2010 01:03 PM, Pan, Jacob jun wrote:
>> Our goal is to have a binary compatible kernel runs on Moorestown and PC, can
>> we keep the Moorestown PCI code for this purpose?
> 
> CONFIG_X86_MRST is supposed to reflect the *ability* to run on
> Moorestown, not the *requirement* of running on Moorestown.  As such,
> Yinghai's patch seems correct to me.
> 
> If you cannot boot a kernel with CONFIG_X86_MRST=y on PC hardware, that
> is a bug which should be fixed.

yes, at 64 bit doesn't need that code yet.

that pci_fixed_bar_fixup cause my nehalem-ex box warm reset...

YH
