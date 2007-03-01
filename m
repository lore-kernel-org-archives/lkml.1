Return-Path: <linux-kernel-owner+w=401wt.eu-S965317AbXCAQOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965317AbXCAQOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 11:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965315AbXCAQOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 11:14:18 -0500
Received: from de01egw02.freescale.net ([192.88.165.103]:37703 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965317AbXCAQOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 11:14:17 -0500
Message-ID: <45E6FBC5.4060705@freescale.com>
Date: Thu, 01 Mar 2007 10:13:57 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.2pre) Gecko/20070111 SeaMonkey/1.1
MIME-Version: 1.0
To: Dan Malek <dan@embeddedalley.com>
CC: Torben.Mathiasen@hp.com, Segher Boessenkool <segher@kernel.crashing.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       linux-ppc-embedded <linuxppc-embedded@ozlabs.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: lanana: Add major/minor entries for PPC QE UART devices
References: <45E46976.6060600@freescale.com>	<45E592DC.9060700@freescale.com>	<511cacb7bbe8a65ff72738c84ec9ece4@kernel.crashing.org>	<BD465924-7387-47EF-B90F-606F215819C2@embeddedalley.com>	<45E5B604.904@freescale.com> <46F6BF70-2922-4E05-8DAB-6B0830B0AB47@embeddedalley.com> <45E5BD6B.1010509@freescale.com> <F2D0230C-CA22-4DEF-917E-6982FA0C6171@embeddedalley.com> <45E5C128.7020204@freescale.com> <45E5C333.2060100@zytor.com> <ED6BD6F0-827F-4ADC-9D66-F9C3DD7FC470@embeddedalley.com> <E919B903-0890-4725-81CF-005003A1A2F6@kernel.crashing.org> <45E5D627.6030707@zytor.com> <45E5D84A.5000502@freescale.com> <278AADB6-E175-4177-A728-5357E21697B7@kernel.crashing.org> <45E5DB49.8010205@freescale.com> <A6EED9FC-4CE4-4089-ACB8-A1C7A3C50FDD@embeddedalley.com> <a2fc3b0b25c4ad798b63b03763256a2f@kernel.crashing.org> <BE8D549F-71E4-43DE-B624-A8E4A50D094D@embeddedalley.com> <45E6F78A.7070603@freescale.com> <D077F753-DA34-47AD-8F8F-76643A0DD692@embeddedalley.com>
In-Reply-To: <D077F753-DA34-47AD-8F8F-76643A0DD692@embeddedalley.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Malek wrote:

> Don't worry about it for now.  We'll just keep this in
> mind when we make a major change someday in
> the future.  We may have a better solution then.

Ok, what about udev?  If a user is running udev, which supposedly doesn't care about minor 
numbers, won't the user still be limited to 4 UARTS?  If so, is there a way for the driver 
to detect udev and allow 8 UARTS?

-- 
Timur Tabi
Linux Kernel Developer @ Freescale
