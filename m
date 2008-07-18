Return-Path: <linux-kernel-owner+w=401wt.eu-S1759314AbYGRQWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbYGRQWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 12:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbYGRQW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 12:22:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:50546 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbYGRQW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 12:22:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=g3bPhxXv6hDMDMRal89UhGHitkPxf4TcffF//LQJQpJ1+lLrV0cxmMprrmQ52hAoOu
         ZVS/XE7L5R+9jaFcRB52s2oR7Jpi/0husnZOtDlG6DQFJxBM4qKmpaEVJyP2yy4So0cd
         J3Y3/c0dOrIytj9RWHsC3KN0sThXmErO3SEIg=
Message-ID: <86802c440807180922l3500082chf7dcf0a1bafc6629@mail.gmail.com>
Date: Fri, 18 Jul 2008 09:22:26 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bernhard Walle" <bwalle@suse.de>
Subject: Re: [PATCH] x86: Move crashkernel reservation before dma32_reserve_bootmem()
Cc: akpm@linux-foundation.org, x86@kernel.org, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, vgoyal@redhat.com
In-Reply-To: <20080718115213.3c87f8f8@halley.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216332945-17197-1-git-send-email-bwalle@suse.de>
	 <86802c440807171550t360a2a76mddb9ae45c7e9f4fb@mail.gmail.com>
	 <20080718115213.3c87f8f8@halley.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 2:52 AM, Bernhard Walle <bwalle@suse.de> wrote:
> * Yinghai Lu [2008-07-17 15:50]:
>>
>> > +       /*
>> > +        * dma32_reserve_bootmem() allocates bootmem which may conflict
>> > +        * with the crashkernel command line, so do that before
>> > +        */
>> > +       reserve_crashkernel();
>> > +
>> >  #ifdef CONFIG_X86_64
>> >        dma32_reserve_bootmem();
>> >  #endif
>> > @@ -808,7 +814,6 @@ void __init setup_arch(char **cmdline_p)
>> >         */
>> >        find_smp_config();
>> >  #endif
>> > -       reserve_crashkernel();
>> >
>> >        reserve_ibft_region();
>>
>> Joe Jin already had another one to move dma32_reserve_bootmem later
>
> Commit id? Current status?

it seems commit description from you is more good.
please create one version move dma32_reserve_boot_mem after
reserve_crashkernel and use your commit description.

YH
