Return-Path: <linux-kernel-owner+w=401wt.eu-S1758473AbYFLULL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473AbYFLULL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 16:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756484AbYFLUKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 16:10:55 -0400
Received: from senator.holtmann.net ([87.106.208.187]:46800 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbYFLUKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 16:10:54 -0400
Subject: Re: [PATCH] HP iLO driver
From: Marcel Holtmann <marcel@holtmann.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Altobelli <david.altobelli@hp.com>, linux-kernel@vger.kernel.org
In-Reply-To: <48516CF2.106@zytor.com>
References: <20080612182308.GA1091@ldl.fc.hp.com>  <48516CF2.106@zytor.com>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 22:13:52 +0200
Message-Id: <1213301632.17870.75.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> > A driver for the HP iLO/iLO2 management processor, which allows userspace
> > programs to query the management processor.  Programs can open a channel
> > to the device (/dev/hpilo_ccbN), and use this to send/receive queries.  
> > The O_EXCL open flag is used to indicate that a particular channel cannot
> > be shared between processes.  This driver will replace various packages
> > HP has shipped, including hprsm and hp-ilo.
> 
> Wouldn't /dev/hpilo/ccbN be a more appropriate namespace?

this is udev's job.

Regards

Marcel


