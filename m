Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbZGOOPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbZGOOPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 10:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbZGOOPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 10:15:05 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:58271 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753318AbZGOOPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 10:15:04 -0400
X-Sasl-enc: QQFY5ERgqX1xQ9sodeUpYXB+56e7GBbeksEqvf+bNTXN 1247667302
Date: Wed, 15 Jul 2009 11:14:59 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regression] Re: 2.6.31-rc2: thinkpad boots with backlight low
Message-ID: <20090715141459.GA22098@khazad-dum.debian.net>
References: <20090714092513.GB2010@elf.ucw.cz>
 <20090714104712.GB19866@khazad-dum.debian.net>
 <20090715131351.GA2367@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090715131351.GA2367@elf.ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009, Pavel Machek wrote:
> ...and yes, I think it only happens on reboot.

It could be thinkpad-acpi, but it is unlikely.  Lets try one simple test:

1. blacklist thinkpad-acpi so that it doesn't load.

2. boot (without thinkpad-acpi), adjust backlight, then try to reproduce the
problem.  Make sure to test both reboot and shutdown.

That will tell us if it is thinkpad-acpi or not...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
