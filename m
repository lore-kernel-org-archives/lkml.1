Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbYLJXV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbYLJXV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 18:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbYLJXVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 18:21:43 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:49848 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753496AbYLJXVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 18:21:42 -0500
X-Sasl-enc: DKuBJQbvq5drhzzKXalVIRGQcrcXeDDaNMFmDOYbXUxd 1228951301
Date: Wed, 10 Dec 2008 21:21:37 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Witold Szczeponik <Witold.Szczeponik@gmx.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Adam Belay <abelay@mit.edu>,
       rjw@sisk.pl
Subject: Re: [PATCH] PNPACPI: Enable Power Support
Message-ID: <20081210232137.GB7589@khazad-dum.debian.net>
References: <493D8A1F.2090907@gmx.net> <20081210095315.GA20627@khazad-dum.debian.net> <494018E9.2060507@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494018E9.2060507@gmx.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008, Witold Szczeponik wrote:
> Henrique de Moraes Holschuh wrote:
>> On Mon, 08 Dec 2008, Witold Szczeponik wrote:
>>> This patch sets the power of PnP ACPI devices to D0 when they
>>> are activated and to D3 when they are disabled.  The latter is
>>
>> This will likely fix my T43 to power down USB during STR. THANKS!!
>> Now, I just need to check if the ACPI BIOS is smart enough to not do
>> it when they are configured as wake devices [in the BIOS].
>>
>
> Most likely it won't. :-(  My patch takes only care of devices that are
> properly registered as PnP by ACPI: attached USB devices don't fall
> under that category.

I do mean the UHCI and EHCI bridges, not USB devices hanging off them :)

I will do an in-depth study of the AML in question, I just noticed it is
coupled to some EC magic register, which might be doing stuff the USB
subsystem just can't do normally.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
