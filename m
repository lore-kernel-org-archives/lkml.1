Return-Path: <linux-kernel-owner+w=401wt.eu-S932500AbXB1WIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500AbXB1WIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 17:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932503AbXB1WIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 17:08:30 -0500
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:34360 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932500AbXB1WI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 17:08:29 -0500
In-Reply-To: <A6EED9FC-4CE4-4089-ACB8-A1C7A3C50FDD@embeddedalley.com>
References: <45E46976.6060600@freescale.com>	<29c13109971547687159078eacdea008@kernel.crashing.org>	<45E592DC.9060700@freescale.com>	<511cacb7bbe8a65ff72738c84ec9ece4@kernel.crashing.org>	<BD465924-7387-47EF-B90F-606F215819C2@embeddedalley.com>	<45E5B604.904@freescale.com> <46F6BF70-2922-4E05-8DAB-6B0830B0AB47@embeddedalley.com> <45E5BD6B.1010509@freescale.com> <F2D0230C-CA22-4DEF-917E-6982FA0C6171@embeddedalley.com> <45E5C128.7020204@freescale.com> <45E5C333.2060100@zytor.com> <ED6BD6F0-827F-4ADC-9D66-F9C3DD7FC470@embeddedalley.com> <E919B903-0890-4725-81CF-005003A1A2F6@kernel.crashing.org> <45E5D627.6030707@zytor.com> <45E5D84A.5000502@freescale.com> <278AADB6-E175-4177-A728-5357E21697B7@kernel.crashing.org> <45E5DB49.8010205@freescale.com> <A6EED9FC-4CE4-4089-ACB8-A1C7A3C50FDD@embeddedalley.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <a2fc3b0b25c4ad798b63b03763256a2f@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Kumar Gala <galak@kernel.crashing.org>,
       linux-ppc-embedded <linuxppc-embedded@ozlabs.org>,
       Timur Tabi <timur@freescale.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Torben.Mathiasen@hp.com
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: lanana: Add major/minor entries for PPC QE UART devices
Date: Wed, 28 Feb 2007 23:08:23 +0100
To: Dan Malek <dan@embeddedalley.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Please, let's just leave the four we have

No one is suggesting otherwise.

> and let
> the driver just allocate increasing minor numbers.
> If anyone has a product with more than 4 UARTs,
> they will have to figure out what to do with the
> additional minors.

Since you say no one has ever used more than 4 UARTs,
there are two options:

- Cap the driver at 4 UARTs;
- Assign an extra range of minors for more ports.

Just randomly using some extra minors that aren't
assigned to you isn't such a great idea.


Segher

