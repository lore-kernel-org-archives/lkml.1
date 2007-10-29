Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbXJ2GOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbXJ2GOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 02:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbXJ2GOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 02:14:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:34428 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbXJ2GOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 02:14:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=PcV5G9a5RUuVEjcO36HXH5SGUZKj+8nn6aPT1/XQp4wazP7YMH7Dns+8Rq58Sb5FCcmVY4bDGZQlkdlehI37MaDbFeBIZMG2FpgELqPO3dx51WWRvgg83QytroVTz4xF1HF3bNn/VRrrZYWy1jDi+CldUWOBIlhnztDISjgAL/8=
Message-ID: <47257A1C.8050206@gmail.com>
Date: Mon, 29 Oct 2007 15:13:48 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Shane Huang <Shane.Huang@amd.com>
CC: David Miller <davem@davemloft.net>, david.gaarenstroom@gmail.com,
       linux-kernel@vger.kernel.org, jeff@garzik.org, barkalow@iabervon.org,
       linas@austin.ibm.com, gregkh@suse.de, brice.goglin@gmail.com,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-ide@vger.kernel.org,
       brice@myri.com, mchan@broadcom.com
Subject: Re: [PATCH 5/5]: [PCI]: Remove 3 incorrect MSI quirks.
References: <20071025.011716.123998434.davem@davemloft.net> <9783dadb0710260356g4ef94e3dvadf69d4d263c2361@mail.gmail.com> <20071026.043833.88113848.davem@davemloft.net> <5CAB7B5D6F8AB84AA868A46B47A50705623160@sshaexmb1.amd.com>
In-Reply-To: <5CAB7B5D6F8AB84AA868A46B47A50705623160@sshaexmb1.amd.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shane Huang wrote:
>> I would like those to be removed, but to be conservative we should
>> first get some testing feedback that confirms this just like those
>> provided to me from the AMD folks for the RS690, RX790 and RD580
>> cases.
>>
>> Otherwise the risk to break people's systems is very real.
> 
> In fact, our team only has boards with RS690+SB700 and RX790+SB700,
> I don't know why the RD580 MSI is disabled too by the patch
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commi
> t;h=aea6a433f50cd89b9cbd10850fd0b32f961f9883
> Maybe Tejun can give us more information on this case,
> I think the cause should be same as RS690 and RX790.

I don't remember history of each quirk entry but they're either reported
in a bug report and successfully worked around with pci=nomsi or one of
AMD guys told me certain PCI IDs share the same problem.  I can dig mail
archive if you wanna know how it went down for RD580.

-- 
tejun
