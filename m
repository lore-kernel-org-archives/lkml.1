Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbXFNFxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbXFNFxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 01:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbXFNFxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 01:53:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:59985 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbXFNFxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 01:53:04 -0400
In-Reply-To: <59453d80f2f111b72e8f24e7b489c23e@kernel.crashing.org>
References: <11816389393593-git-send-email-wei.zhang@freescale.com> <1181638939310-git-send-email-wei.zhang@freescale.com> <39c7d60cebf03badd106d7f75a08f449@kernel.crashing.org> <46B96294322F7D458F9648B60E15112C526DD9@zch01exm26.fsl.freescale.net> <59453d80f2f111b72e8f24e7b489c23e@kernel.crashing.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <CF39A363-25C6-4780-96EC-6750D77C287F@kernel.crashing.org>
Cc: "Zhang Wei-r63237" <Wei.Zhang@freescale.com>,
       <linux-kernel@vger.kernel.org>, <mporter@kernel.crashing.org>,
       <paulus@samba.org>, <linuxppc-dev@ozlabs.org>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH 1/5] Add the explanation and sample of RapidIO DTS sector to the document of booting-without-of.txt file.
Date: Thu, 14 Jun 2007 00:53:11 -0500
To: Segher Boessenkool <segher@kernel.crashing.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> Some silicons of Freescale processor are the same RapidIO controller,
>> such as mpc8540/mpc8560 are the same (v0.0), mpc8548/mpc8641 are the
>> same (v1.0). For v1.0 RapidIO controller, should we use mpc8548 or
>> mpc8641? Those will make people confused.
>
> Not at all.  On an 8641 it could be
>
> 	compatible = "fsl,mpc8641-rapidio" "fsl,mpc8548-rapidio";
>
> which states "this is the 8641 thing and it is compatible
> to the 8548 thing".  Perfectly clear.

The concern is this isn't just compatible = "..8641.." "..8548.." but  
something like:

"..8641.." "..8641d.." "..8548.." "..8548e.." "..8543.." "..8543e.."  
"..8572.." "..8572e.." "..8567.." "..8567e.." "..8568.." "..8568e.."

>> Using IP Block Revision is a
>> clear choice.
>
> I don't think so.  For one thing, it describes a version of
> a cell design, not a version of an actual device.  For another
> thing, if I hear "8641" I know what you're talking about (sort
> of, anyway), but I draw a blank stare if you say "v1.0".  I'm
> sure I'm not the only one.  Concrete names are good.

While I agree concrete names are good, we put these 'blocks' in so  
many devices that using the device to match on is pointless.

I'm all for making up a name like 'Grande', 'Del', 'Janeiro'.  This  
is effective what we did with gianfar.  The name gets picked up  
pretty quickly by people.

- k
