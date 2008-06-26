Return-Path: <linux-kernel-owner+w=401wt.eu-S1759208AbYFZOej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208AbYFZOej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 10:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbYFZOe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 10:34:28 -0400
Received: from gw.goop.org ([64.81.55.164]:52212 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225AbYFZOe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 10:34:27 -0400
Message-ID: <4863A8E6.1010807@goop.org>
Date: Thu, 26 Jun 2008 07:34:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <npiggin@suse.de>, Mark McLoughlin <markmc@redhat.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Stephen Tweedie <sct@redhat.com>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Xen-devel] Re: [PATCH 00 of 36] x86/paravirt: groundwork for
 64-bit Xen support
References: <patchbomb.1214367536@localhost> <20080625084253.GA11524@elte.hu>	<20080625152212.GA3442@elte.hu> <4862A6A9.1030109@goop.org>	<20080626105722.GA12640@elte.hu> <20080626105818.GA13805@elte.hu>
In-Reply-To: <20080626105818.GA13805@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>> that fixed the build but now we've got a boot crash with this config:
>>     
>
> plus -tip auto-testing found another build failure with:
>
>  http://redhat.com/~mingo/misc/config-Thu_Jun_26_12_46_46_CEST_2008.bad
>
> arch/x86/kernel/entry_64.S: Assembler messages:
> arch/x86/kernel/entry_64.S:1201: Error: invalid character '_' in mnemonic
> arch/x86/kernel/entry_64.S:1205: Error: invalid character '_' in mnemonic
> arch/x86/kernel/entry_64.S:1209: Error: invalid character '_' in mnemonic
> arch/x86/kernel/entry_64.S:1213: Error: invalid character '_' in mnemonic
>
>   

I'm confused.  How did this config both crash and not build?

    J

