Return-Path: <linux-kernel-owner+w=401wt.eu-S1758675AbYBBLa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675AbYBBLa2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 06:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbYBBLaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 06:30:17 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52985 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754040AbYBBLaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 06:30:15 -0500
X-Sasl-enc: oGNzpTVo9F30nyKQJfEXmNSVhFbhskCvCdImWK+OvfmQ 1201951813
Date: Sat, 2 Feb 2008 09:30:08 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Len Brown <lenb@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH] Rationalise ACPI backlight implementation
Message-ID: <20080202113008.GA4251@khazad-dum.debian.net>
References: <20071226020325.GA21099@srcf.ucam.org> <20080128012549.GA24166@srcf.ucam.org> <20080127211013.1ddaa6a1.akpm@linux-foundation.org> <200802012246.13162.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802012246.13162.lenb@kernel.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Feb 2008, Len Brown wrote:
> You might check if CONFIG_ACPI_VIDEO=m is set and you can load the "video" module.
> While the sony may be non-standard and not load, your thinkpad may work.

It will work except under new X.org, which disables BIOS backlight
functionality in order to do it directly, at least on Intel GPUs (and
probably also on ATI GPUs.  nVidia is no-man's-land).

And I have been told that X.org can do 256 backlight levels on Intel
hardware *including* switching the backlight off, instead of just the 16
levels Lenovo chose to export through ACPI.   Looks like someone should
add a kernel framebuffer device for those Intels :)

We really need to solve the userspace mess, though.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
