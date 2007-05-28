Return-Path: <linux-kernel-owner+w=401wt.eu-S1760636AbXE1BZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636AbXE1BZZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 21:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbXE1BZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 21:25:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:65182 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbXE1BZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 21:25:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Wws1l+frUU9veYYDsWDjNsA/hJOI3E6m8D+hvt+ScDymv+TrqOOsNy74PPLgaPzgDanFtF8RHD3QBsSZpwVv3SlGknrYtYqnbiuEdCS0GtU8k5kikoVK2I7y6PAIhj5PTpqPuhLuKy1hDEa6xSIlnaYHYhlMADSfOJ1HyUG8bLk=
Message-ID: <465A2F6F.6070900@gmail.com>
Date: Mon, 28 May 2007 05:25:03 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Grant Grundler <grundler@parisc-linux.org>, Greg KH <greg@kroah.com>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCIE
References: <20070523155958.GA5282@kroah.com> <4654AB40.6060208@gmail.com>	<adaejl79rh0.fsf@cisco.com> <4654BC10.2000808@gmail.com>	<adazm3v89hv.fsf@cisco.com> <4654C85B.6060505@gmail.com>	<adatzu385g1.fsf@cisco.com> <46561287.8020103@gmail.com>	<ada1wh560u1.fsf@cisco.com> <46584C30.4030206@gmail.com>	<20070526182828.GA7080@colo.lackof.org> <46588A3D.2060208@gmail.com> <adaps4l21fe.fsf@cisco.com>
In-Reply-To: <adaps4l21fe.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > >> Another question would be if the device supports multiple messages, MSIX
>  > >> should be used ?
>  > > 
>  > > Yes. Assuming the device supports multiple MSI-X messages.
> 
> At least on my device (PCI ID 1131:7162) there is no MSI-X capability,
> so that's not an option for you.  The current Linux implementation
> does not support more than one MSI interrupt, so you just get one
> interrupt with pci_enable_msi().
> 
> I think it's probably simplest for you to forget about MSI until you
> have the basic driver working.

Damn. The NXP guys don't want me to go ahead with the generic registers.

What they said :

> And if you really use the SAA7162 in the PC application,
> pls ignore the 0x520 .....
> That's not a good decision to use that.

Might need to ask them why it would not be a good decision then. :-(
