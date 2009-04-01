Return-Path: <linux-kernel-owner+w=401wt.eu-S1756297AbZDAQvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbZDAQvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 12:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbZDAQvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 12:51:05 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:60978 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbZDAQvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 12:51:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rZx1uPLoNzCr9bTCIgs1x/sTZXxcvzJ2250B2P13aALj4T4tG9NtN6IaL5O8utECYp
         KWmNj54TBwxtj75pzvBxirAQ9mo0ShQsin05UTU2GP5hDgtyfxMUcX2aJQlvuO0OcqCx
         UqvJ6pV4o9BIxOMAYKjVni0eN98wyC2+vFnn0=
MIME-Version: 1.0
In-Reply-To: <20090331230217.GA31599@srcf.ucam.org>
References: <20090331214501.GC29489@srcf.ucam.org>
	 <20090331214749.GD29489@srcf.ucam.org>
	 <74962ea30903311506m41306659td0cd70c5736f6660@mail.gmail.com>
	 <20090331221107.GA30383@srcf.ucam.org>
	 <74962ea30903311519s2fb6087fxfe8859e3c570ac99@mail.gmail.com>
	 <20090331230217.GA31599@srcf.ucam.org>
Date: Thu, 2 Apr 2009 09:50:59 +1700
Message-ID: <74962ea30904010950u31fbdca3w51eafb9b7ec1ca73@mail.gmail.com>
Subject: Re: [PATCH 2/2] toshiba-acpi: Support TOS1900-type devices
From: Azael Avalos <coproscefalo@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, dsilvers@simtec.co.uk,
       toshiba_acpi@memebeam.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 1, 2009 at 4:02 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> Ok, can you try this and let me know what codes it generates (if it
> generates any)? It should go on top of the previous patches.

Nothing gets generated, even if I change the method to ".INFO" and hotkey
events enabled with hci_write2(HCI_HOTKEY_EVENT, 1, 1, &hci_result) and
TECF set to 1 (see my DSDT).

I was playing with the code yesterday trying to get some events reported, but no
luck so far.

It appears that TOHK variable is _volatile_ and it just stores hotkey events
temporarily and they don't get _stored_ like in the System Event FIFO.

On the patches I sent to the omnibook module I'm able to get events but they
seem to get repeated 3 times, or perhaps I'm polling to often.


Saludos
Azael


-- 
-- El mundo apesta y vosotros apestais tambien --
