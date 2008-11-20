Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbYKTTk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbYKTTk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 14:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbYKTTkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 14:40:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:40118 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbYKTTkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 14:40:51 -0500
Message-ID: <4925BD21.9020701@kernel.org>
Date: Thu, 20 Nov 2008 11:40:17 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 30 of 38] xen: implement io_apic_ops
References: <patchbomb.1226603398@abulafia.goop.org> <d103c0da2fa147ac31af.1226603428@abulafia.goop.org> <20081120093506.GB6885@elte.hu> <492597B9.8070506@goop.org> <20081120192218.GF3955@elte.hu> <4925BA86.7000409@kernel.org> <4925BCDA.3030604@goop.org>
In-Reply-To: <4925BCDA.3030604@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Yinghai Lu wrote:
>> Ingo Molnar wrote:
>>
>>  
>>> it certainly looks thin enough to me although i'm really not sure we
>>> want to virtualize at the IO-APIC level. Peter, what's your
>>> opinion/preference?
>>>
>>>     
>>
>> relative fixed mapping, always make it simple and tracked easily.
>> like irq nr == gsi nr...
> 
> That was a bit terse for me to understand your point.  The code already
> has irq==gsi.  Are you proposing that it stay that way

yes

YH


