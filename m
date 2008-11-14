Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbYKNRHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbYKNRHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 12:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbYKNRH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 12:07:28 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:4226 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbYKNRH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 12:07:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=Kr7lpQiIFGAU1zsO1g+GJ6kTUWBaPryRUDT+olju3hPfWQQWLfCj4S7yfujJvr+USc
         sEZkAQSAO1662Ma8aDH2hHGvYv2yUEnyNUrpGA9fMhwYFGO4z+te/cODE17nRBpWC4uU
         n8BnFoDhquK6/0SnVZjDF92am0xSooCavbElc=
Message-ID: <491DB048.3090308@tuffmail.co.uk>
Date: Fri, 14 Nov 2008 17:07:20 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: Add option to passively listen for PCIE hotplug events
References: <20081104124706.GB19401@srcf.ucam.org> <20081104133214.GA20427@srcf.ucam.org> <49105BA6.9090403@tuffmail.co.uk> <20081104143332.GA21689@srcf.ucam.org> <491063B3.4080808@tuffmail.co.uk> <20081104151128.GA22544@srcf.ucam.org> <49106DD7.9010307@tuffmail.co.uk> <20081104155722.GA23314@srcf.ucam.org> <491076BD.1030704@tuffmail.co.uk> <49170B16.4010909@tuffmail.co.uk> <20081114161631.GA28234@srcf.ucam.org>
In-Reply-To: <20081114161631.GA28234@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Sun, Nov 09, 2008 at 04:08:54PM +0000, Alan Jenkins wrote:
>
>   
>> Bump.  In case you're still slightly confused, I've found out why.  It 
>> skips the slot power check because POWER_CTRL(ctrl) == 0.  (See "Power 
>> Controller" in the debug output below).
>>     
>
> Ok. I'm beginning to think that this approach is misguided. The Aspire 
> One should be handled by the acpiphp changes I've posted. The Eee makes 
> significantly less sense to me. It runs XP, so it can't depend on native 
> PCIe hotplugging. It sends ACPI notifications when the kill state 
> changes but there's no topological relationship between the device that 
> receives them and the device that needs to be hotplugged.
>
> What I'm actually beginning to suspect is that this should be handled by 
> eee-laptop. Can you give the following patch a go, without any pciehp 
> code loaded?
>
>   
Will do.

Note that Xandros say the newest model EeePC (S101) 'is now using a
"normal" kill of the antenna, which is easier to work with'.

http://sourceforge.net/mailarchive/message.php?msg_name=48D6AC5E.70502%40xandros.com

So if you're unlucky, the current eeepc-laptop worked perfectly on the
S101, and now it will simply refuse to load :).  But it's probably safer
that way.  At least the 701 runs quite adequately without eeepc-laptop. 
I guess it can be fixed when someone interested gets their hands on an S101.

Thanks
Alan
