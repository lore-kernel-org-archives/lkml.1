Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651AbYLJTbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbYLJTbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 14:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbYLJTbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 14:31:09 -0500
Received: from mail.gmx.net ([213.165.64.20]:45441 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754795AbYLJTbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 14:31:08 -0500
X-Authenticated: #787645
X-Provags-ID: V01U2FsdGVkX1/IW5dCzXXIs6KaUjG6Lv0+cbYYzQLgNIDcJ8Tieb
	5KhUlbwDkRUPgS
Message-ID: <494018E9.2060507@gmx.net>
Date: Wed, 10 Dec 2008 20:30:49 +0100
From: Witold Szczeponik <Witold.Szczeponik@gmx.net>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Adam Belay <abelay@mit.edu>,
       rjw@sisk.pl
Subject: Re: [PATCH] PNPACPI: Enable Power Support
References: <493D8A1F.2090907@gmx.net> <20081210095315.GA20627@khazad-dum.debian.net>
In-Reply-To: <20081210095315.GA20627@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:

> On Mon, 08 Dec 2008, Witold Szczeponik wrote:
>> This patch sets the power of PnP ACPI devices to D0 when they
>> are activated and to D3 when they are disabled.  The latter is
> 
> This will likely fix my T43 to power down USB during STR. THANKS!!
> Now, I just need to check if the ACPI BIOS is smart enough to not do
> it when they are configured as wake devices [in the BIOS].
> 

Most likely it won't. :-(  My patch takes only care of devices that are
properly registered as PnP by ACPI: attached USB devices don't fall
under that category.

--- Witold

