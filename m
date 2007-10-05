Return-Path: <linux-kernel-owner+w=401wt.eu-S1764660AbXJEVcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764660AbXJEVcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 17:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762412AbXJEVci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 17:32:38 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:53042 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760900AbXJEVch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 17:32:37 -0400
Message-ID: <4706AD62.6030705@freescale.com>
Date: Fri, 05 Oct 2007 16:32:18 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Andreas Schwab <schwab@suse.de>
CC: Anton Altaparmakov <aia21@cam.ac.uk>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: __LITTLE_ENDIAN vs. __LITTLE_ENDIAN_BITFIELD
References: <4706822D.4070509@freescale.com>	<Pine.LNX.4.64.0710052031310.13406@fbirervta.pbzchgretzou.qr>	<470691EB.7020209@freescale.com>	<AECA61F9-0EF6-4883-9D37-004C00C57417@cam.ac.uk>	<4706A842.9030507@freescale.com> <jer6k9mesf.fsf@sykes.suse.de>
In-Reply-To: <jer6k9mesf.fsf@sykes.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab wrote:
> Timur Tabi <timur@freescale.com> writes:
> 
>> The CPU shift operation, yes.  I'm talking about shift operations on
>> external memory-mapped devices.
> 
> That is a property of how the device is wired to the bus.  The cpu will
> always put a value of 128 on the bus such that D7 = 1 and D0-D6 = 0.

Yes, but is D7 on the left or on the right?

Anyway, this is academic now.  I now know that __LITTLE_ENDIAN_BITFIELD is not 
what I want, and that there's no macro that will tell how the lines from the 
CPU to external memory are mapped.

-- 
Timur Tabi
Linux Kernel Developer @ Freescale
