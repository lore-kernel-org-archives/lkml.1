Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbYGaOjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbYGaOjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 10:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbYGaOjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 10:39:11 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:46684 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753223AbYGaOjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 10:39:10 -0400
X-Sasl-enc: X12N8n//ur7LDqYYb1TaVOl6/Pqp9L+Kud0PilWmTPGs 1217515148
Date: Thu, 31 Jul 2008 11:39:05 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Sysrq+B doesn't work on my box
Message-ID: <20080731143905.GF19665@khazad-dum.debian.net>
References: <c4e36d110807310645n3ff6e61j17414433c5aee030@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4e36d110807310645n3ff6e61j17414433c5aee030@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008, Zdenek Kabelac wrote:
> I'd like to get resolved this problem - my T61 machine doesn't reboot
> with SysRQ+B key.
> And I never remember if it was ever rebooting.
> 
> This is all I know so far and I've no idea where could be the problem.

Well, many of the different ThinkPad BIOSes are really sensitive to the
proper boot/reboot/shutdown sequence (whatever it is).  Otherwise, the thing
gets stuck in SMBIOS limbo and hung.  For exeample, we had major issues with
boxes that only shut down half-way and ended up draining the cells to
critical levels, a few months ago.  I don't know what finally fixed THAT
one, but it was ugly.

Here is another example: you can't get the TCO watchdog to reboot all (any?)
thinkpads properly on hardware.  In my T43, the TCO watchdog IS hooked to
something, but the BIOS hates it to trip and the entire box goes to
neverland when it fires...

If sysrq+b uses a different reboot path than the normal reboot path, it is
the first hint of what is missing...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
