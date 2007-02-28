Return-Path: <linux-kernel-owner+w=401wt.eu-S932401AbXB1TZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401AbXB1TZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 14:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932402AbXB1TZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 14:25:58 -0500
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:55167 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932401AbXB1TZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 14:25:57 -0500
In-Reply-To: <ED6BD6F0-827F-4ADC-9D66-F9C3DD7FC470@embeddedalley.com>
References: <45E46976.6060600@freescale.com>	<29c13109971547687159078eacdea008@kernel.crashing.org>	<45E592DC.9060700@freescale.com>	<511cacb7bbe8a65ff72738c84ec9ece4@kernel.crashing.org>	<BD465924-7387-47EF-B90F-606F215819C2@embeddedalley.com>	<45E5B604.904@freescale.com> <46F6BF70-2922-4E05-8DAB-6B0830B0AB47@embeddedalley.com> <45E5BD6B.1010509@freescale.com> <F2D0230C-CA22-4DEF-917E-6982FA0C6171@embeddedalley.com> <45E5C128.7020204@freescale.com> <45E5C333.2060100@zytor.com> <ED6BD6F0-827F-4ADC-9D66-F9C3DD7FC470@embeddedalley.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <ce5df0c760f6b5ab896b31d1ce2839ee@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: linux-ppc-embedded <linuxppc-embedded@ozlabs.org>,
       Timur Tabi <timur@freescale.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Torben.Mathiasen@hp.com
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: lanana: Add major/minor entries for PPC QE UART devices
Date: Wed, 28 Feb 2007 20:25:51 +0100
To: Dan Malek <dan@embeddedalley.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Just allocate the four slots and we'll deal with
> anything above this in custom products.

Another option is to use 46..49 for UARTs #0..3,
and 192..195 for UARTs #4..7.

Or, perhaps better, use 46..49 for #0..3, and
192..199 for #0..7, handling the duplication in
the driver; and deprecate the old range.


Segher

