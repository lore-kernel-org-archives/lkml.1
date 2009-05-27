Return-Path: <linux-kernel-owner+w=401wt.eu-S933818AbZE0S1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933818AbZE0S1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764526AbZE0S0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:26:46 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:44112 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933843AbZE0S0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:26:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=pzOc9CYIa42kN/i3OrOYBUiYhUmHyJQMtp3133aivi55CmImoAn//9KW7ub8qEkjF8
         zBqt1vbJV5Xyc98592Fd8v4ispF03Vye4MRMjvH1Y8Ws+/g32yS8Z0omm+IEv/Gz88jl
         9h7WdznlsmHAcO5KqoffMAi+A6ER+yc3uYIhA=
To: Scott Wood <scottwood@freescale.com>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>,
       rmk@arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
References: <1243408083.13460.14.camel@debian-nb>
	<fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com>
	<ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com>
	<20090527150527.GK6805@pengutronix.de>
	<87vdnm8sec.fsf@macbook.be.48ers.dk> <4A1D6901.2090508@freescale.com>
From: Peter Korsgaard <jacmet@sunsite.dk>
Date: Wed, 27 May 2009 20:26:43 +0200
In-Reply-To: <4A1D6901.2090508@freescale.com> (Scott Wood's message of "Wed\, 27 May 2009 11\:23\:29 -0500")
Message-ID: <87r5ya8krg.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Scott" == Scott Wood <scottwood@freescale.com> writes:

Hi,

 >> Just bundle the .dtb with the kernel and they'll always be in sync. I
 >> know this isn't really in the spirit of OF, but currently imho the
 >> only realistic solution.

 Scott> That removes the ability to use the device tree to pass information
 Scott> from the bootloader, such as MAC addresses and clock frequencies.  On
 Scott> the u-boot list, you'll find people trying such hacks (which were
 Scott> rightly NACKed) as passing the information in the device's volatile
 Scott> registers (which the Linux driver must then not reset) to deal with
 Scott> ARM Linux's lack of this ability.

No, with the multi-image support U-Boot has full access to the device
tree. E.G. I adjust the flash partition list defined in the .dtb in my
board's ft_board_setup() routine.

-- 
Bye, Peter Korsgaard
