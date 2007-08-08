Return-Path: <linux-kernel-owner+w=401wt.eu-S1762846AbXHHME3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762846AbXHHME3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 08:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbXHHMEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 08:04:21 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60544 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751573AbXHHMEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 08:04:20 -0400
X-Sasl-enc: 8rv7X2L/+/gx/QNIti4HLtNZ0oRXeisqsLLfa99aszdc 1186574659
Date: Wed, 8 Aug 2007 09:04:16 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, ibm-acpi-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [ibm-acpi-devel] suspend/hibernation regression between 2.6.19
	and 2.6.20 w/ Thinkpad T41
Message-ID: <20070808120416.GA554@khazad-dum.debian.net>
References: <200708051902.18801.toralf.foerster@gmx.de> <200708071521.33679.toralf.foerster@gmx.de> <200708071738.24502.rjw@sisk.pl> <200708081122.55036.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200708081122.55036.toralf.foerster@gmx.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Aug 2007, Toralf Förster wrote:
> Am Dienstag, 7. August 2007 17:38 schrieb Rafael J. Wysocki:
> > Actually, you don't need the patch above, just do
> > "echo shutdown > /sys/power/disk" before the hibernation (or use
> > BTW, can you please try this patch before you do that:
> > http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.23-rc2/patches/19-ACPI-Enable-GPEs-before-_WAK-is-called.patch
> 
> This patch applied at commit cfee47f doesn't solve the regression.
> 
> > 
> > So place "echo shutdown > /sys/power/disk" before that into your script.
> yep, that works for me.

FYI, some other thinkpad models break badly if you use shutdown instead of
platform.  Sound goes away on wake, etc.

I am still very suspicious that the way we do wake-from-suspend-to-disk is
to blame... I wish we loaded the kernel just once, maybe from the boot
loader.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
