Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab0AOXkX (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 18:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932384Ab0AOXkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 18:40:20 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:43091 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932370Ab0AOXkT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 18:40:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=nGuy229Mxj1HlKkbGM4WYYXTr/jEXsI7uqhh2N1CnD2g93Isq4AtQHMsOxzDb5vTlmFOS0YmqvIvvCsBtdBlYH7Hf0geI1ljykdYkCCFCg+RE7dqJUXitKm+KAk427db;
Date: Fri, 15 Jan 2010 15:40:20 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: =?UTF-8?B?UmVuw6k=?= Bolldorf <xsecute@googlemail.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][CORRECTED] section mismatch: 
 pcibios_scan_specific_bus()
Message-ID: <20100115154020.6823ea3e@jbarnes-piketon>
In-Reply-To: <4B4E3E20.1@googlemail.com>
References: <4B4E3E20.1@googlemail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jan 2010 22:41:52 +0100
René Bolldorf <xsecute@googlemail.com> wrote:

> Hi all,
> pcibios_scan_specific_bus() is only invoked from
> __devinit pcibios_fixup_peer_bridges(void).
> 
> Mark it as __devinit.
> Sry for the first mail, I hadn't sleep enough...
> 
> diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
> --- a/arch/x86/pci/legacy.c
> +++ b/arch/x86/pci/legacy.c
> @@ -39,7 +39,7 @@ static int __init pci_legacy_init(void)
>          return 0;
>   }
> 
> -void pcibios_scan_specific_bus(int busn)
> +void __devinit pcibios_scan_specific_bus(int busn)
>   {
>          int devfn;
>          long node;

Doesn't apply to my for-linus branch, also missing a Signed-off-by.  I
guess you need more sleep. :)  Care to refresh if it's still necessary?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
