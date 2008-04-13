Return-Path: <linux-kernel-owner+w=401wt.eu-S1757568AbYDMCpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbYDMCpw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 22:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbYDMCpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 22:45:41 -0400
Received: from rv-out-0708.google.com ([209.85.198.241]:28166 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752635AbYDMCpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 22:45:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=v8W+qAsGhFJpf5XhmRHWvXG4oXSpGKOW0vPgrlYq8gPKQzb2g8IVvtqtvoVtfJpYkaVCaLzTfLZmqdefS8BIK6488PABH/x71rnTZP0KrPT9nYvVi9+xMqNsQoQoahU9oEYmI3lIEh8mMUa4TonUrm73bGx0fuDHMc4b+LceL0Q=
Message-ID: <480173CB.5070805@gmail.com>
Date: Sun, 13 Apr 2008 11:45:31 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Rich West <Rich.West@wesmo.com>,
       Wander Winkelhorst <w.winkelhorst@gmail.com>,
       linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: sata_via
References: <47F694C8.8020507@wesmo.com> <47F6A5E8.1030602@garzik.org>	 <47F6BD55.3090708@wesmo.com> <5699f8f00804050015kb1ebb1cpf3ab8b587580fffd@mail.gmail.com> <47F7982E.5080701@wesmo.com> <47F7F463.2060402@garzik.org>
In-Reply-To: <47F7F463.2060402@garzik.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Rich West wrote:
>> I was only curious as to what turning off power management support 
>> would buy with regard to the sata timeout issue.
> 
> 
> ACPI is not only power management.  It is all the information your 
> hardware conveys to your OS, about the setup and workings of your hardware.
> 
> Without ACPI, non-PM things like SMP, laptop dock/undock, and many other 
> gadgets fail to function (or are configured sub-optimally).
> 
> ACPI sets up interrupt routing, and Linux history is _loaded_ with 
> _years_ of problem reports that appear as timeouts, only to be resolved 
> as ACPI interrupt bugs (aka BIOS bugs, since ACPI tables come from BIOS).

Also, please give a shot at the sacred "irqpoll".

-- 
tejun
