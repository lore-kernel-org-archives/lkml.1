Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab0APPNL (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 10:13:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972Ab0APPNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 10:13:09 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:62553 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab0APPNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 10:13:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=B6BLRtbE5uekv4BSdY5ivzscFPwFdDAAcLijbPLZvLj9Mie++uUX+/++tQYExdhwyY
         PSLSbAJPHGkjWyi9fqcEvtc5f2irVgrYCsBvIY+jTPxAtOhFXsb3NoRTqxYPH8r5QkSO
         CuHl8tHC8LXpH879TsGsHyD/JIC6V6/JUEXR4=
Message-ID: <4B51D787.9040409@googlemail.com>
Date: Sat, 16 Jan 2010 16:13:11 +0100
From: =?UTF-8?B?UmVuw6kgQm9sbGRvcmY=?= <xsecute@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][CORRECTED] section mismatch: pcibios_scan_specific_bus()
References: <4B4E3E20.1@googlemail.com> <20100115154020.6823ea3e@jbarnes-piketon>
In-Reply-To: <20100115154020.6823ea3e@jbarnes-piketon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/10 00:40, Jesse Barnes wrote:
> On Wed, 13 Jan 2010 22:41:52 +0100
> René Bolldorf<xsecute@googlemail.com>  wrote:
>
>> Hi all,
>> pcibios_scan_specific_bus() is only invoked from
>> __devinit pcibios_fixup_peer_bridges(void).
>>
>> Mark it as __devinit.
>> Sry for the first mail, I hadn't sleep enough...
>>
>> diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
>> --- a/arch/x86/pci/legacy.c
>> +++ b/arch/x86/pci/legacy.c
>> @@ -39,7 +39,7 @@ static int __init pci_legacy_init(void)
>>           return 0;
>>    }
>>
>> -void pcibios_scan_specific_bus(int busn)
>> +void __devinit pcibios_scan_specific_bus(int busn)
>>    {
>>           int devfn;
>>           long node;
>
> Doesn't apply to my for-linus branch, also missing a Signed-off-by.  I
> guess you need more sleep. :)  Care to refresh if it's still necessary?
>
> Thanks,

I pulled today 
git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 
linux-next. pci legacy was deleted.
Now patch can be ignored.
