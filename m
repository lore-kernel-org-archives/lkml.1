Return-Path: <linux-kernel-owner+w=401wt.eu-S1765900AbXHGNOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765900AbXHGNOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 09:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758668AbXHGNOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 09:14:35 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:51473 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbXHGNOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 09:14:34 -0400
Date: Tue, 7 Aug 2007 15:15:35 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Javier Pello <javier.pello@urjc.es>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] request_firmware: skip timeout if userspace was not
 notified
Message-ID: <20070807151535.1b3dc050@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1186491472.3611.33.camel@lov.localdomain>
References: <46B37CF7.2020803@urjc.es>
	<20070806142451.5d28d41c@gondolin.boeb
 lingen.de.ibm.com>
	<46B7832B.6010808@urjc.es>
	<20070807125844.4d756b04@gondo
 l	in.boeblingen.de.ibm.com>
	<3ae72650708070446y6452d13jb7cd802119dab3ce@mail
 .gmail.com>
	<20070807141030.1bb0f76a@gondolin.boeblingen.de.ibm.com>
	<46B869C6.3090708@urjc.es>
	<1186491472.3611.33.camel@lov.localdomain>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Aug 2007 14:57:52 +0200,
Kay Sievers <kay.sievers@vrfy.org> wrote:

> The real fix would be to change the driver not to block in the firmware
> request and use async version of firmware loading.

I guess some drivers want to fail the probe if they can't get the
firmware. This sounds like the "some parts of ->probe may take ages and
block everything else" problem again...
