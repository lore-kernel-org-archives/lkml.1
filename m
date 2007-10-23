Return-Path: <linux-kernel-owner+w=401wt.eu-S1755395AbXJWS31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbXJWS31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 14:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbXJWS3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 14:29:08 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:59646 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbXJWS3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 14:29:06 -0400
Subject: Re: [BUG] rfcomm]
From: Marcel Holtmann <marcel@holtmann.org>
To: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Jiri Kosina <jikos@jikos.cz>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net
In-Reply-To: <9e0cf0bf0710231127o485a52e1sc7a06df7c8bc0189@mail.gmail.com>
References: <200710231950.31313.alon.barlev@gmail.com>
	 <1193162106.6184.208.camel@violet>
	 <Pine.LNX.4.64.0710232004260.18815@twin.jikos.cz>
	 <1193163905.6184.214.camel@violet>
	 <9e0cf0bf0710231127o485a52e1sc7a06df7c8bc0189@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 23 Oct 2007 20:30:10 +0200
Message-Id: <1193164210.6184.221.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alon,

> > nice. I've never used it. Currently I am using what comes with Ubuntu
> > 7.10 and that seems to work.
> 
> Have you tried to suspend while pppd is using rfcomm?
> 
> The fact that it happens with suspend2 and uswsusp means that the
> issue is suspend blind.
> Do you need any more information in order to determine what is the problem?

the code in net/bluetooth/rfcomm/tty.c contains two calls to
device_move(). Please comment these out and try again. At least then we
know that it is in issue on how we use the driver model.

Regards

Marcel


