Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbXJXIoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbXJXIoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 04:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbXJXIoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 04:44:12 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:24228 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbXJXIoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 04:44:11 -0400
Date: Wed, 24 Oct 2007 10:43:52 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Alon Bar-Lev" <alon.barlev@gmail.com>
Cc: "Marcel Holtmann" <marcel@holtmann.org>, "Jiri Kosina" <jikos@jikos.cz>,
       linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net
Subject: Re: [BUG] rfcomm]
Message-ID: <20071024104352.294d3b03@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <9e0cf0bf0710231155n71cf38fey4d1edae6401db173@mail.gmail.com>
References: <200710231950.31313.alon.barlev@gmail.com>
	<1193162106.6184.208.camel@violet>
	<Pine.LNX.4.64.0710232004260.18815@twin.jikos.cz>
	<1193163905.6184.214.camel@violet>
	<9e0cf0bf0710231127o485a52e1sc7a06df7c8bc0189@mail.gmail.com>
	<1193164210.6184.221.camel@violet>
	<9e0cf0bf0710231155n71cf38fey4d1edae6401db173@mail.gmail.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007 20:55:54 +0200,
"Alon Bar-Lev" <alon.barlev@gmail.com> wrote:

> On 10/23/07, Marcel Holtmann <marcel@holtmann.org> wrote:
> > the code in net/bluetooth/rfcomm/tty.c contains two calls to
> > device_move(). Please comment these out and try again. At least then we
> > know that it is in issue on how we use the driver model.
> 
> No bugs...
> Looks OK, although I don't know what removed :)

Hm, this might be similar to
http://marc.info/?l=linux-kernel&m=119124209009812&w=2. To confirm,
could you try with CONFIG_DEBUG_DRIVER and CONFIG_DEBUG_KOBJECT set
(and the device_move() calls in again)?
