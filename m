Return-Path: <linux-kernel-owner+w=401wt.eu-S935482AbXJPUJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935482AbXJPUJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 16:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759319AbXJPUJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 16:09:07 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60073 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759387AbXJPUJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 16:09:05 -0400
Date: Tue, 16 Oct 2007 22:09:04 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Mark Gross <mgross@linux.intel.com>
cc: Giacomo Catenazzi <cate@debian.org>, Sam Ravnborg <sam@ravnborg.org>,
       Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Subject: Re: WANTED: kernel projects for CS students
In-Reply-To: <20071016200623.GB23157@linux.intel.com>
Message-ID: <Pine.LNX.4.64.0710162207540.4548@fbirervta.pbzchgretzou.qr>
References: <20071014190128.6e3cdb44@bree.surriel.com> <20071015170411.GB18550@linux.intel.com>
 <20071015183017.GB23130@uranus.ravnborg.org> <4713C582.4000504@debian.org>
 <20071016200623.GB23157@linux.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 16 2007 13:06, Mark Gross wrote:
>
>base function:
>Starting from a stock distro (FC, Ubuntu, OpenSuSE...) and put down a
>kernel.org tree and automatically create a .config with all the drivers
>needed for the platform I'm building on.

Too easy. Since opensuse's udev loads most of the modules for your hardware,
all that would be needed is to transform the lsmod list of modules plus
the static options in /proc/config.gz (stuff like psmouse) back
into kconfig options ;-)
