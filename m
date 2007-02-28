Return-Path: <linux-kernel-owner+w=401wt.eu-S932375AbXB1TVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375AbXB1TVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 14:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932386AbXB1TVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 14:21:50 -0500
Received: from de01egw02.freescale.net ([192.88.165.103]:48725 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932375AbXB1TVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 14:21:50 -0500
Message-ID: <45E5D621.1050005@freescale.com>
Date: Wed, 28 Feb 2007 13:21:05 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; it; rv:1.8.1) Gecko/20061010 Firefox/2.0 
MIME-Version: 1.0
To: Dan Malek <dan@embeddedalley.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Torben.Mathiasen@hp.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       linux-ppc-embedded <linuxppc-embedded@ozlabs.org>
Subject: Re: lanana: Add major/minor entries for PPC QE UART devices
References: <45E46976.6060600@freescale.com>	<29c13109971547687159078eacdea008@kernel.crashing.org>	<45E592DC.9060700@freescale.com>	<511cacb7bbe8a65ff72738c84ec9ece4@kernel.crashing.org>	<BD465924-7387-47EF-B90F-606F215819C2@embeddedalley.com>	<45E5B604.904@freescale.com> <46F6BF70-2922-4E05-8DAB-6B0830B0AB47@embeddedalley.com> <45E5BD6B.1010509@freescale.com> <F2D0230C-CA22-4DEF-917E-6982FA0C6171@embeddedalley.com> <45E5C128.7020204@freescale.com> <45E5C333.2060100@zytor.com> <ED6BD6F0-827F-4ADC-9D66-F9C3DD7FC470@embeddedalley.com>
In-Reply-To: <ED6BD6F0-827F-4ADC-9D66-F9C3DD7FC470@embeddedalley.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Malek wrote:

> Just allocate the four slots and we'll deal with
> anything above this in custom products. 

Assuming that this is the agreed-upon standard, should I arbitrarily restrict my driver to 
4 ports, or allow all 8?

I assume that if a driver already claims a particular major/minor combo, then when the 2nd 
driver calls uart_add_one_port(), that call will fail?

-- 
Timur Tabi
Linux Kernel Developer @ Freescale
