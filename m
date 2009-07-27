Return-Path: <linux-kernel-owner+w=401wt.eu-S1753474AbZG0M2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbZG0M2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 08:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbZG0M2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 08:28:37 -0400
Received: from ox1.aei.mpg.de ([194.94.224.6]:41019 "EHLO ox1.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbZG0M2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 08:28:36 -0400
X-Greylist: delayed 1546 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jul 2009 08:28:36 EDT
Date: Mon, 27 Jul 2009 14:01:42 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Ferenc Wagner <wferi@niif.hu>,
       Kay Sievers <kay.sievers@vrfy.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bisected] [Bug #13821] Replugging USB serial converter uses
	new device node
Message-ID: <20090727120142.GA13407@Pilar.aei.mpg.de>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.p7C.WHObKB@chimera> <20090727022623.GA6614@Pilar.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090727022623.GA6614@Pilar.aei.mpg.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 27.Jul'09 at  4:26:23 +0200, Carlos R. Mafra wrote:
> 
> So I bisected it to commit 335f8514f200e63d689113d29cb7253a5c282967
> ("tty: Bring the usb tty port structure into more use"), from Alan
> Cox.
> 
> I did not double check if reverting it from -rc4 fixes the issue,
> but I noticed that this patch touches drivers/usb/serial/option.c, which
> is the driver I used to test this problem.

It doesn't revert cleanly from -rc4, but I solved the conflicts in
option.c and usb-serial.c (I wanted to learn how to do it) 
and the problem gets fixed indeed.
