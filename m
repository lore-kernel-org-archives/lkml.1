Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbZJFNjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbZJFNjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 09:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757246AbZJFNjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 09:39:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50133 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754389AbZJFNjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 09:39:39 -0400
Date: Tue, 6 Oct 2009 14:40:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: felipe.balbi@nokia.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>
Subject: Re: TTY loosing bytes ?
Message-ID: <20091006144012.1af5744a@lxorguk.ukuu.org.uk>
In-Reply-To: <20091006132752.GZ4452@nokia.com>
References: <20091006094845.GT4452@nokia.com>
	<20091006114528.GV4452@nokia.com>
	<20091006131230.5301f711@lxorguk.ukuu.org.uk>
	<20091006130150.GY4452@nokia.com>
	<20091006141115.12ad22dd@lxorguk.ukuu.org.uk>
	<20091006132752.GZ4452@nokia.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> unfortunately it didn't work. Although now I don't the debugging prints
> complaining we've lost bytes, the transfer does get stuck in lot earlier
> stage.
> 
> Maybe this is one fix but there's still other problem with that code ?

Or with completely unrelated code. I guess you need to measure what goes
into receive_buf versus what appears in userspace

Alan
