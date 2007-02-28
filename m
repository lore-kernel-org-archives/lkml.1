Return-Path: <linux-kernel-owner+w=401wt.eu-S1750851AbXB1Rvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750851AbXB1Rvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 12:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbXB1Rvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 12:51:46 -0500
Received: from de01egw02.freescale.net ([192.88.165.103]:63726 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbXB1Rvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 12:51:45 -0500
Message-ID: <45E5C128.7020204@freescale.com>
Date: Wed, 28 Feb 2007 11:51:36 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; it; rv:1.8.1) Gecko/20061010 Firefox/2.0 
MIME-Version: 1.0
To: Dan Malek <dan@embeddedalley.com>
CC: Torben.Mathiasen@hp.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       linux-ppc-embedded <linuxppc-embedded@ozlabs.org>
Subject: Re: lanana: Add major/minor entries for PPC QE UART devices
References: <45E46976.6060600@freescale.com>	<29c13109971547687159078eacdea008@kernel.crashing.org>	<45E592DC.9060700@freescale.com>	<511cacb7bbe8a65ff72738c84ec9ece4@kernel.crashing.org>	<BD465924-7387-47EF-B90F-606F215819C2@embeddedalley.com>	<45E5B604.904@freescale.com> <46F6BF70-2922-4E05-8DAB-6B0830B0AB47@embeddedalley.com> <45E5BD6B.1010509@freescale.com> <F2D0230C-CA22-4DEF-917E-6982FA0C6171@embeddedalley.com>
In-Reply-To: <F2D0230C-CA22-4DEF-917E-6982FA0C6171@embeddedalley.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Malek wrote:

> I'd shoot that down, too.  Using udev in an
> embedded, reliable environment is very
> troublesome.  Although, products I've
> developed using more than 4 UARTs had
> some custom /dev work done to it just
> to get everything mapped.  My only
> concern is we don't add a new range for
> QE UARTs, that we use the same minors
> for both CPM and QE.

Then it appears that the only possible solution is to assign numbers 46 - 53 to the CPM/QE 
and accept that it overlaps with the Altix.  Is everyone okay with that?

-- 
Timur Tabi
Linux Kernel Developer @ Freescale
