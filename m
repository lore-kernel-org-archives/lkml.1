Return-Path: <linux-kernel-owner+w=401wt.eu-S1755695AbXENOEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbXENOEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 10:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbXENOEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 10:04:44 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:60930 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753640AbXENOEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 10:04:44 -0400
Date: Mon, 14 May 2007 16:04:03 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Al Viro <viro@ftp.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Make prepare_namespace() wait for devices
Message-ID: <20070514160403.6414f149@dhcp-252-105.norway.atmel.com>
In-Reply-To: <46486A7F.8050705@drzeus.cx>
References: <464853D9.70904@drzeus.cx>
	<20070514123436.GB4095@ftp.linux.org.uk>
	<46486A7F.8050705@drzeus.cx>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007 15:56:15 +0200
Pierre Ossman <drzeus-list@drzeus.cx> wrote:

> > As for the patch, an infinite loop is *much* worse than a panic.
> > When one is installing a new kernel on remote box, having it
> > booted with reboot on panic and loader falling back to old
> > kernel on the next boot is a bloody good idea - gives you extra
> > safety.  With your patch it will get the box stuck.
> >     
> 
> Ok. So a timeout or having the entire thing Kconfig optional?

How about command-line optional?

Haavard
