Return-Path: <linux-kernel-owner+w=401wt.eu-S1423199AbXBUXRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423199AbXBUXRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423248AbXBUXRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:17:15 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:39978 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423199AbXBUXRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:17:13 -0500
X-Sasl-enc: F85KINYAGeRoi//Kq4WhdThKxZBxoDPs81YCLSYD1cZH 1172099911
Date: Wed, 21 Feb 2007 21:17:06 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Alex Romosan <romosan@sycorax.lbl.gov>,
       Yaroslav Halchenko <kernel@onerussian.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       James Simmons <jsimmons@infradead.org>
Subject: Re: no backlight on radeon after recent kernel "upgrade"s
Message-ID: <20070221231706.GA3336@khazad-dum.debian.net>
References: <20070219044616.GC25659@washoe.onerussian.com> <20070219000412.acad13de.akpm@linux-foundation.org> <1171876788.6046.3.camel@localhost.localdomain> <877iub9mu2.fsf@sycorax.lbl.gov> <1172097718.5790.29.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172097718.5790.29.camel@localhost.localdomain>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007, Richard Purdie wrote:
> enabled. On a thinkpad, the backlight is probably under ACPI control.

BIOS+ACPI, actually.  Without ACPI video loaded, the firmware does
everything correctly.  With ACPI video, the firmware does it, then its
changes are clobbered over by ACPI video's.

If ibm-acpi is loaded, a backlight device "ibm" is added.  ibm-acpi's ibm
backlight device can change the display brightness.  It is *not* capable of
turning the backlight on or off, AFAIK.

BTW, some ThinkPads don't have a Radeon, but rather an Intel GM/GMX device.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
