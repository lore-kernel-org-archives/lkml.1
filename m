Return-Path: <linux-kernel-owner+w=401wt.eu-S965289AbXCAPsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965289AbXCAPsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 10:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965300AbXCAPsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 10:48:45 -0500
Received: from smtp106.biz.mail.re2.yahoo.com ([206.190.52.175]:44622 "HELO
	smtp106.biz.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965289AbXCAPso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 10:48:44 -0500
X-YMail-OSG: ISzwIxoVM1l7HGkY_76N5PhlNbUEvzLg87VKfc95josfomby98YMNBN676zTO9KRb.IehzI.yEIrw2PAm1eIUbbk7cU2pTuKA1x5ynFOoputr3TIneqQxRIqv9pOHBzZDCtR55r9vHPfUbQ-
In-Reply-To: <a2fc3b0b25c4ad798b63b03763256a2f@kernel.crashing.org>
References: <45E46976.6060600@freescale.com>	<29c13109971547687159078eacdea008@kernel.crashing.org>	<45E592DC.9060700@freescale.com>	<511cacb7bbe8a65ff72738c84ec9ece4@kernel.crashing.org>	<BD465924-7387-47EF-B90F-606F215819C2@embeddedalley.com>	<45E5B604.904@freescale.com> <46F6BF70-2922-4E05-8DAB-6B0830B0AB47@embeddedalley.com> <45E5BD6B.1010509@freescale.com> <F2D0230C-CA22-4DEF-917E-6982FA0C6171@embeddedalley.com> <45E5C128.7020204@freescale.com> <45E5C333.2060100@zytor.com> <ED6BD6F0-827F-4ADC-9D66-F9C3DD7FC470@embeddedalley.com> <E919B903-0890-4725-81CF-005003A1A2F6@kernel.crashing.org> <45E5D627.6030707@zytor.com> <45E5D84A.5000502@freescale.com> <278AADB6-E175-4177-A728-5357E21697B7@kernel.crashing.org> <45E5DB49.8010205@freescale.com> <A6EED9FC-4CE4-4089-ACB8-A1C7A3C50FDD@embeddedalley.com> <a2fc3b0b25c4ad798b63b03763256a2f@kernel.crashing.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <BE8D549F-71E4-43DE-B624-A8E4A50D094D@embeddedalley.com>
Cc: Kumar Gala <galak@kernel.crashing.org>,
       linux-ppc-embedded <linuxppc-embedded@ozlabs.org>,
       Timur Tabi <timur@freescale.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Torben.Mathiasen@hp.com
Content-Transfer-Encoding: 7bit
From: Dan Malek <dan@embeddedalley.com>
Subject: Re: lanana: Add major/minor entries for PPC QE UART devices
Date: Thu, 1 Mar 2007 10:48:45 -0500
To: Segher Boessenkool <segher@kernel.crashing.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 28, 2007, at 5:08 PM, Segher Boessenkool wrote:

> Since you say no one has ever used more than 4 UARTs,
> there are two options:

People have used more than 4, but we just
allocated the additional /dev entries to cover
them.  I know of only one time this has happened.
It's such a custom case that the other device
names didn't matter.

> - Cap the driver at 4 UARTs;

Let's do this, but design the code to
allow more by just changing a #define.

> Just randomly using some extra minors that aren't
> assigned to you isn't such a great idea.

Maybe for a desktop or generic server where
you don't know what's going to be configured,
but it's not unusual to do so with custom
embedded systems.  The small experimental
or user allocations often don't cover what
is needed, so we just grab some allocation
from a device that isn't ever going to be
used on the system.


Thanks.

	-- Dan

