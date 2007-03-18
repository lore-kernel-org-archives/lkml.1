Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026AbXCRFlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbXCRFlX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 01:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbXCRFlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 01:41:23 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:33288 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbXCRFlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 01:41:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=lALqM4TpVcblsiP50ixhM/Qb+zAyoJxRd5HM9R6cw6U0WW8qWoLF1XLCgEV+1PWTDKG7e5CF18bQYhTRYsZmcm3F5Vx+3WRdM+rSVC2M5fkHaUsOJ3WIDMViqV9OgFxwNqyI0xZf0oSMPuSEZLGjpoY5VM6KvvAbzJJx8OkrWNs=
Message-ID: <45FCD0FB.70507@gmail.com>
Date: Sun, 18 Mar 2007 14:41:15 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Jon Masters <jonathan@jonmasters.org>
CC: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       Conke Hu <conke.hu@gmail.com>
Subject: Re: Loading both the pata_atiixp and the ahci driver causes problems
References: <45F9C3F5.4070906@redhat.com> <45F9F5F0.3090508@jonmasters.org>
In-Reply-To: <45F9F5F0.3090508@jonmasters.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Masters wrote:
> Chuck Ebbert wrote:
> 
>> If you try to load both the pata_atiixp and the ahci driver
>> (for the same ATI SB600 adapter), very strange things happen.
>> The AHCI driver churns for three minutes or so, spewing
>> messages like this, then nothing works:
>>
>> <6>ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> <4>ata3.00: qc timeout (cmd 0xec)
>> <4>ata3.00: failed to IDENTIFY (I/O error, err_mask=0x104)
> 
>> Shouldn't it be able to tell the device has already been
>> claimed by some other driver?
> 
> One would assume it'd fail to grab the PCI IO ranges twice? I haven't
> looked at the code but I have seen this bug mentioned elsewhere so I
> might well end up having to do that yet :-)

Dunno much about sb600 but ahci and pata_atiixp are probably using
separate IO regions && separate PCI functions.

Conke, care to educate us a bit here?

-- 
tejun
