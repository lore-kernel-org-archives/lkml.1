Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbXFNHwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbXFNHwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 03:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbXFNHw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 03:52:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:52850 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbXFNHwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 03:52:25 -0400
In-Reply-To: <CF39A363-25C6-4780-96EC-6750D77C287F@kernel.crashing.org>
References: <11816389393593-git-send-email-wei.zhang@freescale.com> <1181638939310-git-send-email-wei.zhang@freescale.com> <39c7d60cebf03badd106d7f75a08f449@kernel.crashing.org> <46B96294322F7D458F9648B60E15112C526DD9@zch01exm26.fsl.freescale.net> <59453d80f2f111b72e8f24e7b489c23e@kernel.crashing.org> <CF39A363-25C6-4780-96EC-6750D77C287F@kernel.crashing.org>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <2e7b08497aae9219233aed72628e46c6@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: <mporter@kernel.crashing.org>, <linux-kernel@vger.kernel.org>,
       "Zhang Wei-r63237" <Wei.Zhang@freescale.com>, <linuxppc-dev@ozlabs.org>,
       <paulus@samba.org>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 1/5] Add the explanation and sample of RapidIO DTS sector to the document of booting-without-of.txt file.
Date: Thu, 14 Jun 2007 09:52:06 +0200
To: Kumar Gala <galak@kernel.crashing.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> Not at all.  On an 8641 it could be
>>
>> 	compatible = "fsl,mpc8641-rapidio" "fsl,mpc8548-rapidio";
>>
>> which states "this is the 8641 thing and it is compatible
>> to the 8548 thing".  Perfectly clear.
>
> The concern is this isn't just compatible = "..8641.." "..8548.." but 
> something like:
>
> "..8641.." "..8641d.." "..8548.." "..8548e.." "..8543.." "..8543e.." 
> "..8572.." "..8572e.." "..8567.." "..8567e.." "..8568.." "..8568e.."

You don't need to mention _all_ compatible devices in
the "compatible" property, only the few that matter;
typically the oldest one, and sometimes some intermediate
device that has extra features over the original one.

It isn't useful to add "compatible" entries that no OS
probes for.

>> Concrete names are good.
>
> While I agree concrete names are good, we put these 'blocks' in so 
> many devices that using the device to match on is pointless.

You *definitely* should put the device name for _this_
device in there, in case it needs some special workaround.

> I'm all for making up a name like 'Grande', 'Del', 'Janeiro'.  This is 
> effective what we did with gianfar.  The name gets picked up pretty 
> quickly by people.

That can be used as the "base" name, yes.


Segher

