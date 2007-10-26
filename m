Return-Path: <linux-kernel-owner+w=401wt.eu-S1758252AbXJZK5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252AbXJZK5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 06:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbXJZK44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 06:56:56 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:55013 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbXJZK4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 06:56:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eAaVwfAAmVR86WkVQ4cc56682aUNQAe1vnvi3R2xa9uZGt6AZt4FQtWym73/GDHdxFiy3O5zLipc21KIE74FTftDYcrXJEoHf4lADRLbzLZoWwk6zgKxcTPHL3YOW613jMIjaZOzzPKARg7kSxnikXzNu7FhaZFNWolohPf9+q4=
Message-ID: <9783dadb0710260356g4ef94e3dvadf69d4d263c2361@mail.gmail.com>
Date: Fri, 26 Oct 2007 12:56:52 +0200
From: "David Gaarenstroom" <david.gaarenstroom@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5/5]: [PCI]: Remove 3 incorrect MSI quirks.
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, barkalow@iabervon.org,
       linas@austin.ibm.com, chunhao.huang@hotmail.com, gregkh@suse.de,
       htejun@gmail.com, brice.goglin@gmail.com,
       linux-pci@atrey.karlin.mff.cuni.cz, shane.huang@amd.com,
       linux-ide@vger.kernel.org, brice@myri.com, mchan@broadcom.com
In-Reply-To: <20071025.011716.123998434.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071025.011716.123998434.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/10/25, David Miller <davem@davemloft.net>:
>
> Now that we have dealt with the real issue, in that some ATI SATA and
> USB controllers needed the INTX_DISABLE quirk, we can remove these AMD
> chipset global MSI disabling quirks.

IMHO we should remove *all* former ATI "AMD" chipset global MSI
disabling quirks... The whole idea was to sort things out once and for
all. At least the RS480 quirk can be removed, now that the USB driver
has the workaround for the SB400 southbridge USB. I suspect the same
counts for the other ATI chipsets...

To quote Greg K-H:
"But for now, let's not take a band-aid that prevents others from
working to solve the real issues here."
