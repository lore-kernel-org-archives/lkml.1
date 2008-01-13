Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbYAMXlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbYAMXlr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 18:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbYAMXlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 18:41:36 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:59685 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753525AbYAMXle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 18:41:34 -0500
X-Sasl-enc: UIDqfluCRy7DesXX220iq1Y/ofDmAjY5r05xZcF3MaRG 1200267693
Date: Sun, 13 Jan 2008 21:41:29 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Lenovo ThinkPads need acpi_osi="Linux"
Message-ID: <20080113234129.GE10693@khazad-dum.debian.net>
References: <20080112022348.GC27524@khazad-dum.debian.net> <200801120416.08631.lenb@kernel.org> <20080113165801.GA4132@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080113165801.GA4132@ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jan 2008, Pavel Machek wrote:
> > The reason it shoudl be turned off is that backlight enabling
> > backlight from a native graphics driver is much faster than running
> > through the video BIOS POST.  So if we keep the OSI(Linux)
> > video BIOS POST workaround in place permanently, it would
> > put Linux at a permanent performance disadvantage to Windows.
> 
> Hmm, they should not need to do anything.
> 
> When linux calls video BIOS with lcall (acpi_sleep=s3_bios), they
> should turn on backlight and put video into text mode. They should
> also make sure mode setting works after that.

IMHO, in that case, we should probably be whitelist-enabling that on
thinkpads (and allow for acpi_sleep=none to override it), or letting
userspace change it at runtime.

> I don't see how ACPI fits into this picture, and I think it can work
> well without ACPI tricks.

It fits because Lenovo did it in ACPI (or used to do it in ACPI, whatever).
We can ask them to not do it, I suppose.  But without some sort of
autodetection on our part, I doubt they will remove it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
