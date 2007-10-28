Return-Path: <linux-kernel-owner+w=401wt.eu-S1757238AbXJ1ULu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbXJ1ULu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 16:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464AbXJ1ULQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 16:11:16 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:63141 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbXJ1ULO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 16:11:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qr0mTerPMPSX/CwomkCXmaayipaAckUMjXk8ZePsrjmDO4OTQjLfrBFZkMKgD9GoKCmOor9EGxeVSvgo6gsRXVxwtzKBcJBSIyHXNi38nCrBNgDGkivor6W1UylmPCqFDnFNzePuEyhDLVkAlDfAusLoVcR9K8SFJkSeOfj2SnY=
Message-ID: <9783dadb0710281311o619a6bd4r2f7b1c4cbaa325e9@mail.gmail.com>
Date: Sun, 28 Oct 2007 21:11:13 +0100
From: "David Gaarenstroom" <david.gaarenstroom@gmail.com>
To: "David Miller" <davem@davemloft.net>, shane.huang@amd.com
Subject: Re: [PATCH 5/5]: [PCI]: Remove 3 incorrect MSI quirks.
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, barkalow@iabervon.org,
       linas@austin.ibm.com, chunhao.huang@hotmail.com, gregkh@suse.de,
       htejun@gmail.com, brice.goglin@gmail.com,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-ide@vger.kernel.org,
       brice@myri.com, mchan@broadcom.com
In-Reply-To: <20071026.043833.88113848.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071025.011716.123998434.davem@davemloft.net>
	 <9783dadb0710260356g4ef94e3dvadf69d4d263c2361@mail.gmail.com>
	 <20071026.043833.88113848.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I would like those to be removed, but to be conservative we should
> first get some testing feedback that confirms this just like those
> provided to me from the AMD folks for the RS690, RX790 and RD580
> cases.

The patch works fine for my laptop with the RS480 chipset (with a
SB400 southbridge).
But it would be nice if AMD tested it as well...

BTW, here you can see that the SB400 USB controller was the only real
problem for the RS480 chipset in the first place:
http://lkml.org/lkml/2006/12/21/47
