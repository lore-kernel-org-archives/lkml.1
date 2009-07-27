Return-Path: <linux-kernel-owner+w=401wt.eu-S1755605AbZG0XRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbZG0XRd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 19:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbZG0XRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 19:17:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40630 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754744AbZG0XRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 19:17:32 -0400
Date: Tue, 28 Jul 2009 00:17:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Ferenc Wagner <wferi@niif.hu>,
       Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bisected] [Bug #13821] Replugging USB serial converter uses
 new device node
Message-ID: <20090728001740.61b365db@lxorguk.ukuu.org.uk>
In-Reply-To: <20090727172254.GA19576@Pilar.aei.mpg.de>
References: <87zlaqcec1.fsf@tac.ki.iif.hu>
	<Pine.LNX.4.44L0.0907271217441.5217-100000@iolanthe.rowland.org>
	<20090727164857.GA8908@Pilar.aei.mpg.de>
	<20090727175525.20ac4869@lxorguk.ukuu.org.uk>
	<20090727172254.GA19576@Pilar.aei.mpg.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And the fact that is, reverting your commit made things work under
> the same testing conditions.
> 
> Do you have any suggestions as to what I should do between unplugging
> and plugging it back?

Got it - if the port is opened twice (eg by two apps) it does this.
Reproduced and testing a fix.


Alan
