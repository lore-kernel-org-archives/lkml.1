Return-Path: <linux-kernel-owner+w=401wt.eu-S932146AbYBNMZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146AbYBNMZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 07:25:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755632AbYBNMY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 07:24:58 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:43236 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753290AbYBNMY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 07:24:57 -0500
X-Sasl-enc: npBDBPN9xK0/IjFglF7+qExZolyq0OQEywJX2+ojNw3f 1202991896
Date: Thu, 14 Feb 2008 10:24:52 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc1 regression - IBM ACPI backlight
Message-ID: <20080214122452.GB12775@khazad-dum.debian.net>
References: <20080214103801.GB4366@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214103801.GB4366@ics.muni.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008, Lukas Hejtmanek wrote:
> as of 2.6.25-rc1, there is no more /sys/class/backlight/acpi_video1 which
> controlled LVDS backlight on Lenovo ThinkPad T61. There is still acpi_video0
> which seems to have sane values but echo N > brightness has no effect at all.
> 
> thinkpad_acpi module reports that ACPI controlled backlight is present.

Please report this to linux-acpi @ vger . kernel . org...

It is likely caused by the stuff to locate and disable the unused video
device in the DSDT (apparently it got the wrong device?!).

However, BEFORE reporting to linux-acpi, please test it in single user mode
without X *ever* being loaded on that boot.  New X disables the BIOS
brightness changes that ACPI uses.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
