Return-Path: <linux-kernel-owner+w=401wt.eu-S1755116AbXDZVQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbXDZVQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 17:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755117AbXDZVQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 17:16:44 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:53164 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115AbXDZVQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 17:16:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ouq6t7HKUKxLJbdwkZ9YLvCwWlM/fEP0kY7oJALQLFWLsvK2mWjBhaHhJIoPaCA3qil7o3Rnc0GQKq4P0Mvpmdd0b8JC37EaKYdM1G3VppRQ1EHhWX5Wa5AADhp+HMQ2UMEseqK9X6Mjho+sUf16lyivf65R9fqaTgLoTU3wKJ0=
Message-ID: <463115F6.7010501@googlemail.com>
Date: Thu, 26 Apr 2007 23:13:26 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Kumar Gala <galak@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: 2.6.21-rc7-mm2
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>	<46309142.2010907@googlemail.com> <20070426133720.25085207.akpm@linux-foundation.org> <46311231.3090903@freescale.com>
In-Reply-To: <46311231.3090903@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi wrote:
> Andrew Morton wrote:
>
>   
>>> drivers/net/Kconfig:2327:warning: 'select' used by config symbol 
>>> 'UCC_GETH' refer to undefined symbol 'UCC_FAST'
>>>       
>> Yes, we get so many of those that I tend to ignore them, assuming that
>> someone will pick it up and fix it.
>>     
>
> Is this being compiled on a non-ppc/powerpc platform?  

Yes , on i386 with this config :


http://crazy.dev.frugalware.org/2.6.21-rc7-mm2/config

> That might explain it.  UCC_GETH is 
> defined in drivers/net/Kconfig, but UCC_FAST is defined in 
> arch/powerpc/sysdev/qe_lib/Kconfig.  So I supposed if you don't compile for ARCH=powerpc, 
> then arch/powerpc/sysdev/qe_lib/Kconfig is never loaded?
>
> If that's the case, then we're always going to have this problem with platform-dependent 
> drivers in the /drivers/ directory.  The ucc_geth driver depends on the "QE library", 
> which is present only on some PowerPC processors, so we put the config options for the QE 
> in arch/powerpc.  But since ucc_geth is a standard Ethernet driver, it exists in drivers/net.
>
>   

Gabriel
