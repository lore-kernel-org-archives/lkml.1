Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbXE1CEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbXE1CEt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 22:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbXE1CEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 22:04:41 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:42693 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbXE1CEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 22:04:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=WQyp8jLRc0vlcDbQzAJ4v0REjxxKwInQvCp/VYJIDV5F+/cggjmBlOBLjQLRaiWnR1Opmzsh/0kmp1rPGzkNwpA0j/ugS8Ic4RK2phKWnF8yXhzebVvTQVNd97+qFRd/eIalQVBUYg0mE4GsnoEzMkXpAO6v4ftLOvTdLu6R/VU=
Message-ID: <465A38B0.6030604@gmail.com>
Date: Mon, 28 May 2007 06:04:32 +0400
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
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
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

This would mean MSI or MSI-X ?  A bit confused now.

• MSI capability
- 32 different messages
- programmable ID in MSI message data field
- programmable TC in MSI message address field


