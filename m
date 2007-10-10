Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbXJJQ0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbXJJQ0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 12:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbXJJQ0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 12:26:12 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:9740 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbXJJQ0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 12:26:12 -0400
Date: Wed, 10 Oct 2007 18:26:12 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: wit <is01kzh@gmail.com>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: about probing a device
Message-ID: <20071010182612.1f228ed1@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <105610bf0710100850n2eb3c68codc3781d963df764e@mail.gmail.com>
References: <105610bf0710091839r3b2fc1bfp4260ceaf6ad94b7@mail.gmail.com>
	<20071010130923.004ee895@the-village.bc.nu>
	<105610bf0710100850n2eb3c68codc3781d963df764e@mail.gmail.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2007 23:50:01 +0800,
wit <is01kzh@gmail.com> wrote:

> > The first one which matches and successfully attaches "wins".
> 
> Seems that calling the bind routine can bind a driver to a device. Is
> there any bad side effect of doing such thing?

If the device is already bound to another driver, it will fail.

If you have multiple drivers for the same device, just use the drivers'
bind/unbind attributes if the wrong one "won".
