Return-Path: <linux-kernel-owner+w=401wt.eu-S932409AbXB1Tab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbXB1Tab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 14:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932431AbXB1Tab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 14:30:31 -0500
Received: from de01egw01.freescale.net ([192.88.165.102]:37840 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409AbXB1Taa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 14:30:30 -0500
Message-ID: <45E5D84A.5000502@freescale.com>
Date: Wed, 28 Feb 2007 13:30:18 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; it; rv:1.8.1) Gecko/20061010 Firefox/2.0 
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Kumar Gala <galak@kernel.crashing.org>, Dan Malek <dan@embeddedalley.com>,
       Torben.Mathiasen@hp.com,
       linux-ppc-embedded <linuxppc-embedded@ozlabs.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lanana: Add major/minor entries for PPC QE UART devices
References: <45E46976.6060600@freescale.com>	<29c13109971547687159078eacdea008@kernel.crashing.org>	<45E592DC.9060700@freescale.com>	<511cacb7bbe8a65ff72738c84ec9ece4@kernel.crashing.org>	<BD465924-7387-47EF-B90F-606F215819C2@embeddedalley.com>	<45E5B604.904@freescale.com> <46F6BF70-2922-4E05-8DAB-6B0830B0AB47@embeddedalley.com> <45E5BD6B.1010509@freescale.com> <F2D0230C-CA22-4DEF-917E-6982FA0C6171@embeddedalley.com> <45E5C128.7020204@freescale.com> <45E5C333.2060100@zytor.com> <ED6BD6F0-827F-4ADC-9D66-F9C3DD7FC470@embeddedalley.com> <E919B903-0890-4725-81CF-005003A1A2F6@kernel.crashing.org> <45E5D627.6030707@zytor.com>
In-Reply-To: <45E5D627.6030707@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Kumar Gala wrote:
>>
>> Why don't we allocate the 2nd group of four as well, just at a new 
>> location.  They'll be discontinuous, but at least we'll have support 
>> for all 8.
>>
> 
> Right, it means two tty driver structures, but that's not a problem.

Eh, I'm not crazy about that.  That means that I have to complicate my driver because 
someone else screwed up a long time ago.

-- 
Timur Tabi
Linux Kernel Developer @ Freescale
