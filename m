Return-Path: <linux-kernel-owner+w=401wt.eu-S1757137AbZCGBMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbZCGBMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 20:12:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbZCGBMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 20:12:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:33745 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754911AbZCGBMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 20:12:15 -0500
Message-ID: <49B1C9BE.4010608@kernel.org>
Date: Fri, 06 Mar 2009 17:11:26 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] x86/pci: try to detect host_bridge pci_cfg_space
References: <49B1C50E.5010209@kernel.org> <49B1C69F.70904@zytor.com> <49B1C7F7.1040403@kernel.org> <49B1C909.4080805@zytor.com>
In-Reply-To: <49B1C909.4080805@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Yinghai Lu wrote:
>>
>> currently only found amd and intel host bridge (on cpu or io hub) need
>> this trick.
>> other device we could still use quirks.
>>
> 
> I'd suspect that we might just want to do this for all devices if we
> ever find any, but yes, let's wait until we have a concrete specimen
> before even trying something like that.
> 
> However, it'd be good to have this in the patch description (which
> really is a PCI patch more than an x86 patch, so I'd be happier if it
> went through Jesse than me.)

sure. it could affect IA64 guys with io hubs too.

YH

