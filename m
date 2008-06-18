Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbYFRTxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbYFRTxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 15:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbYFRTxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 15:53:21 -0400
Received: from ag-out-0708.google.com ([72.14.246.240]:30940 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbYFRTxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 15:53:21 -0400
Message-ID: <48596780.7080004@codemonkey.ws>
Date: Wed, 18 Jun 2008 14:52:32 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: devzero@web.de
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, ecollins@vmware.com,
       Javier Guerra <javier@guerrag.com>, Martin Michlmayr <tbm@cyrius.com>
Subject: Re: Linux with kvm-intel locks up VMplayer guest is started
References: <322174127@web.de>
In-Reply-To: <322174127@web.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devzero@web.de wrote:
> i`d like to give a comment about those claims in this thread (see below),  vmware kernel part would be closed source or binary module.
>
> i think, they aren´t. they just are not available via public/opensource code repository.
>
> just go and download workstation 6.5 beta from:
>
> http://download3.vmware.com/software/wkst/VMware-workstation-e.x.p-91182.i386.tar.gz
> (you may need register for that)
>
> unpack and take a look at vmware-distrib/lib/modules/source - there is source for 6 independent kernel
> modules in those .tar files:
>
> vmblock, vmci, vmmon, vmnet, vmppuser and vsock. (~3MB alltogether)
>   

vmmon is sort of a stub that loads the actual monitor which is a binary 
blob.

Regards,

Anthony Liguori

> regards
> roland
>
>
> ------------------------------------------------------------------------------------
>
>   
>> i think what he's saying is that VMWare is a closed binary blob
>> executing in the kernel; so there's no way to certify anything with
>> this.
>>     
>
>   
>> as soon as you put some unknown (and unknowable, unverifiable,
>> untrustable) code in the kernel, you can't know what will work and
>> what won't.
>>     
>
> ------------------------------------------------------------------------------------
>
>   
>> So ask vmware. They have source to both parts we don't."
>>     
>
> ------------------------------------------------------------------------------------
>
>   
>> If the VMware code was upstream, then we could work together to make a 
>> software arbitration mechanism.  It's not, and worse yet, it's closed 
>> source so there's no chance it will be.  Even if someone wrote an 
>> arbitration mechanism and got VMware to use it, it still shouldn't be 
>> merged because KVM would be the only thing using that mechanism 
>> upstream.  I'm not interested in adding kernel infrastructure to support 
>> external binary kernel modules.
>>     
>
> ------------------------------------------------------------------------------------
>
>   
>> VMware is a binary kernel module that's out of kernel.  KVM is not 
>> misbehaving and the fact that VMware breaks when the KVM module is 
>> loaded isn't our problem.  If they submitted their code for inclusion in 
>> mainline, we could possibly come up with solution for arbitrating who is 
>> using VT.
>>     
>
> ------------------------------------------------------------------------------------
>
>
> _______________________________________________________________________
> Jetzt neu! Schützen Sie Ihren PC mit McAfee und WEB.DE. 30 Tage
> kostenlos testen. http://www.pc-sicherheit.web.de/startseite/?mc=022220
>
>   

