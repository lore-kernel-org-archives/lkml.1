Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbYANNHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbYANNHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 08:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbYANNGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 08:06:40 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:39661 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbYANNGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 08:06:38 -0500
X-Sasl-enc: 79zPHSFPdN0Au9WW5eLv4NvJ+BZzpkX9z2Zt6El0tGso 1200315996
Date: Mon, 14 Jan 2008 11:06:33 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Lenovo ThinkPads need acpi_osi="Linux"
Message-ID: <20080114130633.GD20222@khazad-dum.debian.net>
References: <20080112022348.GC27524@khazad-dum.debian.net> <200801120416.08631.lenb@kernel.org> <20080113165801.GA4132@ucw.cz> <20080113234129.GE10693@khazad-dum.debian.net> <20080114003553.GA1698@srcf.ucam.org> <20080114015009.GA2317@srcf.ucam.org> <20080114015718.GA15124@khazad-dum.debian.net> <20080114020352.GA2502@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114020352.GA2502@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2008, Matthew Garrett wrote:
> Userspace is in a better position to make this determination. Of course, 

That's fine with me.

> this also means not passing the Linux OSI to the firmware. Our hardware 
> interaction is sufficiently in flux that any attempt to work around it 
> in the firmware is just going to lead to bizarre breakage down the road.

The Linux OSI string does more. I just found out that it also drives the
MUTE key behaviour (and you want the behaviour *with* the Linux OSI string
loaded).

Some of the behaviours are actually linux-version agnostic.  E.g. we'll
always prefer that the Mute key send a KEY_MUTE event over the keyboard
controller *without* touching the hardware (which is what it does if the
Linux OSI string is *present*) in ThinkPads where there is no
firmware-specific mixer hardware (i.e. the T61 and probably X61).  For such
uses, the OSI string is fine.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
