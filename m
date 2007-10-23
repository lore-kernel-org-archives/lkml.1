Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbXJWRyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbXJWRyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 13:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbXJWRyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 13:54:04 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:59626 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbXJWRyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 13:54:03 -0400
Subject: Re: [BUG] rfcomm]
From: Marcel Holtmann <marcel@holtmann.org>
To: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net
In-Reply-To: <200710231950.31313.alon.barlev@gmail.com>
References: <200710231950.31313.alon.barlev@gmail.com>
Content-Type: text/plain
Date: Tue, 23 Oct 2007 19:55:06 +0200
Message-Id: <1193162106.6184.208.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alon,

> I have this issue for long time (At least from linux-2.6.18).
> I think it is about time I report this... :)
> 
> When coming out of suspend (uswsusp or suspend2) if rfcomm was
> active it creates this dump.
> 
> If you need any more info I will be glad to provide.

first of all, please check if this still happens with 2.6.23, because we
had some patches in the area of the RFCOMM TTY code that might have
fixed this. Second, can you try without uswsusp or suspend2. Both of
them are not upstream and I can't tell how much these would effect this
kind of behavior.

Regards

Marcel


