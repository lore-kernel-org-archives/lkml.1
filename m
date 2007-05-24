Return-Path: <linux-kernel-owner+w=401wt.eu-S1756983AbXEXWdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbXEXWdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbXEXWcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:32:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:45187 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbXEXWct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:32:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Jus57FOkW3nM0pJBcKO6qDViXxbRqam6zhb/hwJ+FPKPylb3d7/Noso9ioHrdgHqdlfy35iaDHXhx8A7bB3AwyfpHfG116vg5N38yxBGIIlPyf56GRRZl/8dN245Q2Ux3LOcy5pEgzISMnyxDfqOPAe0M4V8llQLhrfZkNFJ8Xw=
Message-ID: <46561287.8020103@gmail.com>
Date: Fri, 25 May 2007 02:32:39 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Greg KH <greg@kroah.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCIE
References: <46543045.3030904@gmail.com> <20070523155958.GA5282@kroah.com>	<4654AB40.6060208@gmail.com> <adaejl79rh0.fsf@cisco.com>	<4654BC10.2000808@gmail.com> <adazm3v89hv.fsf@cisco.com>	<4654C85B.6060505@gmail.com> <adatzu385g1.fsf@cisco.com>
In-Reply-To: <adatzu385g1.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:

> Why does the device come up in a state where it generates a stream of
> interrupts as soon as you enable the PCI device?  That's somewhat
> unusual behavior, although certainly not unheard of.
> 

In fact the device wasn't generating a stream of interrupts when loaded
(i guess). It was just that the shared handler was showing all the
interrupts that occurred, since i was not looking at the interrupt
mask/status.

But accessing any registers caused me a flood of interrupts, which froze
the system. excessive printing to the console caused a lockup.

I am now wondering whether the usage of MSI would help in this case and
that i should be using enable_msi before request_irq ?

