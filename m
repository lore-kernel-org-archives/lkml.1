Return-Path: <linux-kernel-owner+w=401wt.eu-S1751729AbXB1TnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729AbXB1TnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 14:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbXB1TnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 14:43:18 -0500
Received: from de01egw02.freescale.net ([192.88.165.103]:52752 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbXB1TnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 14:43:17 -0500
Message-ID: <45E5DB49.8010205@freescale.com>
Date: Wed, 28 Feb 2007 13:43:05 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; it; rv:1.8.1) Gecko/20061010 Firefox/2.0 
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Dan Malek <dan@embeddedalley.com>,
       Torben.Mathiasen@hp.com,
       linux-ppc-embedded <linuxppc-embedded@ozlabs.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lanana: Add major/minor entries for PPC QE UART devices
References: <45E46976.6060600@freescale.com>	<29c13109971547687159078eacdea008@kernel.crashing.org>	<45E592DC.9060700@freescale.com>	<511cacb7bbe8a65ff72738c84ec9ece4@kernel.crashing.org>	<BD465924-7387-47EF-B90F-606F215819C2@embeddedalley.com>	<45E5B604.904@freescale.com> <46F6BF70-2922-4E05-8DAB-6B0830B0AB47@embeddedalley.com> <45E5BD6B.1010509@freescale.com> <F2D0230C-CA22-4DEF-917E-6982FA0C6171@embeddedalley.com> <45E5C128.7020204@freescale.com> <45E5C333.2060100@zytor.com> <ED6BD6F0-827F-4ADC-9D66-F9C3DD7FC470@embeddedalley.com> <E919B903-0890-4725-81CF-005003A1A2F6@kernel.crashing.org> <45E5D627.6030707@zytor.com> <45E5D84A.5000502@freescale.com> <278AADB6-E175-4177-A728-5357E21697B7@kernel.crashing.org>
In-Reply-To: <278AADB6-E175-4177-A728-5357E21697B7@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:

>> Eh, I'm not crazy about that.  That means that I have to complicate my 
>> driver because someone else screwed up a long time ago.
> 
> If not you someone else.  The cost in the driver is small compared to 
> fixing up all the distro's and such.  If you don't provide this change 
> someone else will.

*sigh*

What about major number 205?  It also has the screwed-up /dev/ttyCPM entries, but it has 
more room, and the CPM driver doesn't actually use it.  At least, I can't see where it 
uses it.

-- 
Timur Tabi
Linux Kernel Developer @ Freescale
