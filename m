Return-Path: <linux-kernel-owner+w=401wt.eu-S932295AbXBOAKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295AbXBOAKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 19:10:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932577AbXBOAKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 19:10:53 -0500
Received: from gw.goop.org ([64.81.55.164]:55848 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932295AbXBOAKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 19:10:52 -0500
Message-ID: <45D3A50A.9090303@goop.org>
Date: Wed, 14 Feb 2007 16:10:50 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@osdl.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Ian Pratt <ian.pratt@xensource.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 15/21] Xen-paravirt: Add Xen interface header files
References: <20070213221729.772002682@goop.org>	<20070213221830.619562494@goop.org> <m1k5ykpiwv.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1k5ykpiwv.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>
>   
>> Add Xen interface header files. These are taken fairly directly from
>> the Xen tree and hence the style is not entirely in accordance with
>> Linux guidelines. There is a tension between fitting with Linux coding
>> rules and ease of maintenance.
>>
>> Define macros and inline functions for doing hypercalls into the
>> hypervisor.
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
>> Signed-off-by: Ian Pratt <ian.pratt@xensource.com>
>> Signed-off-by: Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
>> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
>>
>>
>> --
>>  include/asm-i386/hypercall.h          |  416 +++++++++++++++++++++++++++++
>>  include/asm-i386/hypervisor.h         |   72 +++++
>>     
>
> Are hypercall.h and hypervisor.h generic or are they Xen specific.
> If they are Xen specific (as it appears) then are inappropriately
> named.
>   

Thanks for the reminder; I've been meaning to move/rename these.

>>  include/xen/interface/arch-x86_32.h   |  187 +++++++++++++
>>     
> Why isn't this file include-asm-i386/xen/arch-x86_32.h ?
>   

Those files are more or less directly copied from the Xen tree, and its
easier if they don't drift too far in name and directory structure.

    J
