Return-Path: <linux-kernel-owner+w=401wt.eu-S1751058AbXB1Tel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751058AbXB1Tel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 14:34:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbXB1Tel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 14:34:41 -0500
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:58919 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750968AbXB1Tek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 14:34:40 -0500
In-Reply-To: <45E5D84A.5000502@freescale.com>
References: <45E46976.6060600@freescale.com>	<29c13109971547687159078eacdea008@kernel.crashing.org>	<45E592DC.9060700@freescale.com>	<511cacb7bbe8a65ff72738c84ec9ece4@kernel.crashing.org>	<BD465924-7387-47EF-B90F-606F215819C2@embeddedalley.com>	<45E5B604.904@freescale.com> <46F6BF70-2922-4E05-8DAB-6B0830B0AB47@embeddedalley.com> <45E5BD6B.1010509@freescale.com> <F2D0230C-CA22-4DEF-917E-6982FA0C6171@embeddedalley.com> <45E5C128.7020204@freescale.com> <45E5C333.2060100@zytor.com> <ED6BD6F0-827F-4ADC-9D66-F9C3DD7FC470@embeddedalley.com> <E919B903-0890-4725-81CF-005003A1A2F6@kernel.crashing.org> <45E5D627.6030707@zytor.com> <45E5D84A.5000502@freescale.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <278AADB6-E175-4177-A728-5357E21697B7@kernel.crashing.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Dan Malek <dan@embeddedalley.com>,
       Torben.Mathiasen@hp.com,
       linux-ppc-embedded <linuxppc-embedded@ozlabs.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: lanana: Add major/minor entries for PPC QE UART devices
Date: Wed, 28 Feb 2007 13:33:38 -0600
To: Timur Tabi <timur@freescale.com>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 28, 2007, at 1:30 PM, Timur Tabi wrote:

> H. Peter Anvin wrote:
>> Kumar Gala wrote:
>>>
>>> Why don't we allocate the 2nd group of four as well, just at a  
>>> new location.  They'll be discontinuous, but at least we'll have  
>>> support for all 8.
>>>
>> Right, it means two tty driver structures, but that's not a problem.
>
> Eh, I'm not crazy about that.  That means that I have to complicate  
> my driver because someone else screwed up a long time ago.

If not you someone else.  The cost in the driver is small compared to  
fixing up all the distro's and such.  If you don't provide this  
change someone else will.

- k
