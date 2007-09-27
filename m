Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbXI0G5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbXI0G5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 02:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbXI0G5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 02:57:37 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:48626 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbXI0G5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 02:57:36 -0400
Date: Thu, 27 Sep 2007 08:56:58 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Pierre-Yves Paulus <py@idlum.be>
Cc: linux-kernel@vger.kernel.org, Chuck Ebbert <cebbert@redhat.com>,
       BlueZ development <bluez-devel@lists.sourceforge.net>
Subject: Re: Warnings and Oops on 2.6.23-rc6 while activily using rfcomm
 links (mm/slab.c)
Message-ID: <20070927085658.1c66f1c8@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <46FA5E2E.3010300@idlum.be>
References: <46F92364.3080603@idlum.be>
	<46F952BD.4010009@redhat.com>
	<46FA5E2E.3010300@idlum.be>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 15:27:10 +0200,
Pierre-Yves Paulus <py@idlum.be> wrote:

> > Please use CONFIG_SLUB and turn on SLUB debugging. Something is very wrong
> > somewhere...
> 
> I did so, on 2.6.23-rc8. I also did include CONFIG_DEBUG_DRIVER and 
> CONFIG_DEBUG_KOBJECT, following Cornelia Huck's advice.

Did you see any messages (from the driver core) surrounding
kobject_move() usage or the kref badness messages? I'm asking because
refcounting/lifetime issues may be the reason for your problems...
