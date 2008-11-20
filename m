Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbYKTTjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbYKTTjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 14:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbYKTTjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 14:39:10 -0500
Received: from gw.goop.org ([64.81.55.164]:55648 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757229AbYKTTjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 14:39:08 -0500
Message-ID: <4925BCDA.3030604@goop.org>
Date: Thu, 20 Nov 2008 11:39:06 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 30 of 38] xen: implement io_apic_ops
References: <patchbomb.1226603398@abulafia.goop.org> <d103c0da2fa147ac31af.1226603428@abulafia.goop.org> <20081120093506.GB6885@elte.hu> <492597B9.8070506@goop.org> <20081120192218.GF3955@elte.hu> <4925BA86.7000409@kernel.org>
In-Reply-To: <4925BA86.7000409@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> Ingo Molnar wrote:
>
>   
>> it certainly looks thin enough to me although i'm really not sure we 
>> want to virtualize at the IO-APIC level. Peter, what's your 
>> opinion/preference?
>>
>>     
>
> relative fixed mapping, always make it simple and tracked easily.
> like irq nr == gsi nr...

That was a bit terse for me to understand your point.  The code already 
has irq==gsi.  Are you proposing that it stay that way, or something else?

    J
