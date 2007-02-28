Return-Path: <linux-kernel-owner+w=401wt.eu-S1751793AbXB1TpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbXB1TpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 14:45:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbXB1TpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 14:45:14 -0500
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:60727 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751793AbXB1TpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 14:45:11 -0500
In-Reply-To: <45E5D7B7.9040501@zytor.com>
References: <45E46976.6060600@freescale.com>	<29c13109971547687159078eacdea008@kernel.crashing.org>	<45E592DC.9060700@freescale.com>	<511cacb7bbe8a65ff72738c84ec9ece4@kernel.crashing.org>	<BD465924-7387-47EF-B90F-606F215819C2@embeddedalley.com>	<45E5B604.904@freescale.com> <46F6BF70-2922-4E05-8DAB-6B0830B0AB47@embeddedalley.com> <45E5BD6B.1010509@freescale.com> <F2D0230C-CA22-4DEF-917E-6982FA0C6171@embeddedalley.com> <45E5C128.7020204@freescale.com> <45E5C333.2060100@zytor.com> <ED6BD6F0-827F-4ADC-9D66-F9C3DD7FC470@embeddedalley.com> <ce5df0c760f6b5ab896b31d1ce2839ee@kernel.crashing.org> <45E5D7B7.9040501@zytor.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <47493f913dddbec5e420bd7434709291@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: linux-ppc-embedded <linuxppc-embedded@ozlabs.org>,
       Timur Tabi <timur@freescale.com>, Dan Malek <dan@embeddedalley.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Torben.Mathiasen@hp.com
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: lanana: Add major/minor entries for PPC QE UART devices
Date: Wed, 28 Feb 2007 20:45:07 +0100
To: "H. Peter Anvin" <hpa@zytor.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> Another option is to use 46..49 for UARTs #0..3,
>> and 192..195 for UARTs #4..7.
>> Or, perhaps better, use 46..49 for #0..3, and
>> 192..199 for #0..7, handling the duplication in
>> the driver; and deprecate the old range.
>
> That sounds like more hassle than it's worth.  The discontinuous range 
> may be annoying, but it isn't really a huge amount of code.

Yeah.  My suggestion would allow to get rid of that
extra code some day, though (but sure, is that worth
it?)


Segher

