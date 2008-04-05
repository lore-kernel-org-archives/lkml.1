Return-Path: <linux-kernel-owner+w=401wt.eu-S1754985AbYDEVvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbYDEVvt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 17:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbYDEVvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 17:51:39 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40853 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbYDEVvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 17:51:38 -0400
Message-ID: <47F7F463.2060402@garzik.org>
Date: Sat, 05 Apr 2008 17:51:31 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Rich West <Rich.West@wesmo.com>
CC: Wander Winkelhorst <w.winkelhorst@gmail.com>, linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: sata_via
References: <47F694C8.8020507@wesmo.com> <47F6A5E8.1030602@garzik.org>	 <47F6BD55.3090708@wesmo.com> <5699f8f00804050015kb1ebb1cpf3ab8b587580fffd@mail.gmail.com> <47F7982E.5080701@wesmo.com>
In-Reply-To: <47F7982E.5080701@wesmo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rich West wrote:
> I was only curious as to what turning off power management support would 
> buy with regard to the sata timeout issue.


ACPI is not only power management.  It is all the information your 
hardware conveys to your OS, about the setup and workings of your hardware.

Without ACPI, non-PM things like SMP, laptop dock/undock, and many other 
gadgets fail to function (or are configured sub-optimally).

ACPI sets up interrupt routing, and Linux history is _loaded_ with 
_years_ of problem reports that appear as timeouts, only to be resolved 
as ACPI interrupt bugs (aka BIOS bugs, since ACPI tables come from BIOS).

	Jeff


