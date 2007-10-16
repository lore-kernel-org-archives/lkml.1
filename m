Return-Path: <linux-kernel-owner+w=401wt.eu-S1763428AbXJPJTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763428AbXJPJTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 05:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756498AbXJPJTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 05:19:03 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52338 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755098AbXJPJTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 05:19:01 -0400
X-Sasl-enc: Jx1y//2qi/ms5dZS4OA++JSuF+ZIaWpylg/Bwkv9V8gH 1192526340
Date: Tue, 16 Oct 2007 07:18:57 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Jeremy Katz <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, davej@redhat.com
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
Message-ID: <20071016091857.GD15293@khazad-dum.debian.net>
References: <1192481110-9299-1-git-send-email-katzj@redhat.com> <200710152038.10980.jesse.barnes@intel.com> <20071016083611.GB15293@khazad-dum.debian.net> <200710160149.56649.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710160149.56649.jesse.barnes@intel.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007, Jesse Barnes wrote:
> On Tuesday, October 16, 2007 1:36 am Henrique de Moraes Holschuh wrote:
> > You want ACPI video to just pass the messages to userspace when X.org
> > is driving the backlight?  Fine with me.  That *still* doesn't make
> > it right to get these messages as hot key presses over the input
> > layer through the thinkpad-acpi driver.  So the NAK stands.  Any
> > changes should be done to the ACPI video driver in this case.
> 
> So is this really the direction that input is going?  Last time I talked 
> with Dmitry, he seemed ok with adding input events for ACPI and other 
> firmware hotkeys...

Last time the issue was brought up (and I do believe it was because of
thinkpad-acpi :-) ), he made it clear that any events you are to act upon
are fine in input, but events that are just notifications (i.e. the firmware
already did the action) are not.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
