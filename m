Return-Path: <linux-kernel-owner+w=401wt.eu-S1758051AbZFNLTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbZFNLTb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 07:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756260AbZFNLTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 07:19:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36457 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756188AbZFNLTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 07:19:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Benjamin S." <sbenni@gmx.de>
Subject: Re: 2.6.30 enabling cpu1 on resume fails after suspend to memory
Date: Sun, 14 Jun 2009 13:19:40 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, js@sig21.net
References: <20090614120950.116536fa@pluto-lenny.milky.way> <200906141235.24942.rjw@sisk.pl> <20090614125704.2240023d@pluto-lenny.milky.way>
In-Reply-To: <20090614125704.2240023d@pluto-lenny.milky.way>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906141319.40536.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 June 2009, Benjamin S. wrote:
> 
> On Sun, 14 Jun 2009 12:35:24 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > Thanks for the report, the problem seems to be related to the chipset, because
> > I'm unable to reproduce it with SB600 and a fairly new AMD CPU.
> > 
> > Does the resume work if you comment out suspend_device_irqs() and
> > resume_device_irqs() in drivers/base/power/main.c ?
> 
> Yes, 2.6.30 without the two lines resumes without problems.\

Does it help (with the two lines present again) if the kernel is compiled with
CONFIG_PCI_MSI unset?

Rafael
