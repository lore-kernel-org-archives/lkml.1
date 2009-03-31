Return-Path: <linux-kernel-owner+w=401wt.eu-S1763128AbZCaWG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763128AbZCaWG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 18:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034AbZCaWGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 18:06:17 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:54462 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463AbZCaWGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:06:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KZ3Dfc1j5vRv3HBMMQGsH9ilveEe2HJduaQbGtRu6eR5Sit745rKFE+fxQoxZw+s94
         GH0Unrkwz92gHMg6B4Y0cqJFn+h3XDbdYHwynsfIt2G8immug0+LokBRBXSCedM43eab
         9ytjTDhMw6bZ2f/JcRdp7hFDCSl33YADNbA+o=
MIME-Version: 1.0
In-Reply-To: <20090331214749.GD29489@srcf.ucam.org>
References: <20090331214501.GC29489@srcf.ucam.org>
	 <20090331214749.GD29489@srcf.ucam.org>
Date: Wed, 1 Apr 2009 15:06:12 +1700
Message-ID: <74962ea30903311506m41306659td0cd70c5736f6660@mail.gmail.com>
Subject: Re: [PATCH 2/2] toshiba-acpi: Support TOS1900-type devices
From: Azael Avalos <coproscefalo@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, dsilvers@simtec.co.uk,
       toshiba_acpi@memebeam.org, linux-kernel@vger.kernel.org, lenb@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

On Wed, Apr 1, 2009 at 2:47 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> Despite toshiba_acpi exporting TOS1900 as a modalias, it doesn't appear to
> support these machines. They have their HCI method implemented in a
> different but compatible manner and so need a different method address.

Indeed, my Satellite X205-9800 uses that method, however, it only provides
HCI call 0x001E (Hotkey Events) and no System Event FIFO (0x0016),
instead, hotkeys are entered on a variable called TOHK (TOshiba HotKeys?).
Located in my model in

PCI0.LPCB.EC0.TOHK

and it appears that it can be _polled_ tru' method INFO
(TOSH_INTERFACE_2 ".INFO"),
perhaps a small change in the polling to reflect to that method for
TOS1900 devices would be necessary.


On my model the complete call would be:

\\_SB.VALZ.SPFC
\\_SB.VALZ.INFO

Is it different from \\_SB_.VALZ.SPFC or it simply doesn't matter?

Saludos
Azael



-- 
-- El mundo apesta y vosotros apestais tambien --
