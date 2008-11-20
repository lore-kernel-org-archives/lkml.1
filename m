Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbYKTTiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbYKTTiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 14:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbYKTTiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 14:38:10 -0500
Received: from gw.goop.org ([64.81.55.164]:55624 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbYKTTiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 14:38:09 -0500
Message-ID: <4925BC9E.9010006@goop.org>
Date: Thu, 20 Nov 2008 11:38:06 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 30 of 38] xen: implement io_apic_ops
References: <patchbomb.1226603398@abulafia.goop.org> <d103c0da2fa147ac31af.1226603428@abulafia.goop.org> <20081120093506.GB6885@elte.hu> <492597B9.8070506@goop.org> <20081120192218.GF3955@elte.hu>
In-Reply-To: <20081120192218.GF3955@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> it certainly looks thin enough to me although i'm really not sure we 
> want to virtualize at the IO-APIC level. Peter, what's your 
> opinion/preference?
>   

Given that Xen's requirements here are pretty Xen-specific (I don't 
imagine that any other virtualization system would work in the same 
way), I didn't bother trying to come up with a general "virtualization" 
layer at this level - that's why I was pretty blunt about putting xen_* 
calls in without any indirection.  But the code could certainly be 
restructured in a way which would make it simpler to hook Xen as a 
side-effect, so long as it was achieving some other goal as well 
(general cleanup, big iron architecture support, better msi handling, 
whatever...).

    J
