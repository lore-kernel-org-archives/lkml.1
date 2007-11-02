Return-Path: <linux-kernel-owner+w=401wt.eu-S1753680AbXKBIgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbXKBIgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 04:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbXKBIgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 04:36:05 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:54785 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbXKBIgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 04:36:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Lxu4YR1mk1ZDCqV/1MvsaBAQrmBj6dtDQuQGDM9iyEPjBPaCg93OXcmzYkpfKihVsbYhWOP8LC1ni8oTMgrmxV5R1Y/bTa5/o+FpLq5M/QT4LOJBYLyGsZeZ1X3rCPqiT+9eEhaDEd7dXWbSdCKA0i73RXVMsFOC4MMH6hrqOfs=
Message-ID: <877aabc40711020136g1bc5b602p7423c8472da38273@mail.gmail.com>
Date: Fri, 2 Nov 2007 14:06:01 +0530
From: "Amit Shah" <shahamit@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: sata_nv: ata2 errors
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
In-Reply-To: <472A3EBF.1080403@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <877aabc40710250048m41675163x81671097f44bba7f@mail.gmail.com>
	 <20071101133102.1121bc28.akpm@linux-foundation.org>
	 <472A3EBF.1080403@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/2/07, Jeff Garzik <jeff@garzik.org> wrote:
> Andrew Morton wrote:
> > On Thu, 25 Oct 2007 13:18:50 +0530
> > "Amit Shah" <shahamit@gmail.com> wrote:
> >
> >> On 2.6.24-rc1 (AMD Opteron 1216), my sata_nv driver produces this
> >> output on bootup:
> >>
> >> ata2: EH in SWNCQ mode,QC:qc_active 0x1 sactive 0x1
> >> ata2: SWNCQ:qc_active 0x1 defer_bits 0x0 last_issue_tag 0x0
> >> ata2: ATA_REG 0x40 ERR_REG 0x0
> >> ata2: tag : dhfis dmafis sdbfis sacitve
> >> ata2: tag 0x0: 0 1 0 0
> >> ata2.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
> >> ...
> >> ata2.00: status: { DRDY }
> >>
> >
> > Are any other problems observeable?
>
>
> 2.6.24-rc1 is missing the fix for this that is upstream,
> 360737a982b1ae09e1659e0bb27085c03f02f404

Yes, that commit fixed this for me.

Thanks,
Amit.

-- 
Amit Shah
http://www.amitshah.net/
