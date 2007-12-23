Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbXLWGEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbXLWGEt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 01:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296AbXLWGEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 01:04:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54091 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbXLWGEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 01:04:41 -0500
Message-ID: <476DF8B2.2060608@zytor.com>
Date: Sat, 22 Dec 2007 21:57:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
References: <20071222043139.0cd59804@laptopd505.fenrus.org> <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org> <476DB95F.3090801@garzik.org> <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org> <476DE07A.4000204@garzik.org>
In-Reply-To: <476DE07A.4000204@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> 
> 2) It is legal for PCI-Express to put capabilities anywhere in PCI 
> config space, including extended config space.  (I hope our PCI cap 
> walking code checks for overruns...)
> 

Uh, not really.  The classical capability format only has 8-bit 
addresses, and the spec requires that all extended config space that is 
used be claimed by extended capabilities -- a different format chain.

	-hpa
