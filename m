Return-Path: <linux-kernel-owner+w=401wt.eu-S1765819AbXGaQQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765819AbXGaQQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765348AbXGaQQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:16:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:43436 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764568AbXGaQQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:16:04 -0400
In-Reply-To: <46B96294322F7D458F9648B60E15112C74D158@zch01exm26.fsl.freescale.net>
References: <11854393721520-git-send-email-wei.zhang@freescale.com> <11854393733580-git-send-email-wei.zhang@freescale.com> <98CA70A1-9888-4508-A0E9-0EB28C14945F@kernel.crashing.org> <46B96294322F7D458F9648B60E15112C74D158@zch01exm26.fsl.freescale.net>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <363cce0e331102968838e3cb9db5f166@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: "Kumar Gala" <galak@kernel.crashing.org>, paulus@samba.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 1/5 v3] Add the explanation and a sample of RapidIO OF node to the document of booting-without-of.txt file.
Date: Tue, 31 Jul 2007 18:15:48 +0200
To: "Zhang Wei-r63237" <Wei.Zhang@freescale.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> +    - #address-cells : Address representation for
>> "rapidio" devices.
>>> +      This field represents the number of cells needed to represent
>>> +      the RapidIO address of the registers.
>>
>> Can you explain this a little further.  I'm a bit confused by
>> 'RapidIO address of the registers'.
>>
> I want to present "This field represents the number of cells [needed to
> represent the RapidIO address] of the registers."
> Maybe I should remove 'of the registers' to be more clear.

This is completely content-free anyway; the semantics of
#address-cells (and #size-cells, which you forgot) are
already defined in the base OF spec; what you _should_ be
defining here is a) the required value of #address-cells
for a rapidio bus; and b) how addresses on that bus are
represented (simply as a 64-bit integer, encoded as a
pair of 32-bit integers as usual; but it needs to be said).


Segher

