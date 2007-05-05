Return-Path: <linux-kernel-owner+w=401wt.eu-S933907AbXEEVoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933907AbXEEVoX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 17:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933921AbXEEVoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 17:44:23 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59891 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933907AbXEEVoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 17:44:22 -0400
Date: Sat, 5 May 2007 22:48:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Colin Leroy <colin@colino.net>
Cc: Richard Purdie <rpurdie@openedhand.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] led-class.c permission change
Message-ID: <20070505224803.67f76749@the-village.bc.nu>
In-Reply-To: <20070505124954.0e2bcf53@localhost.localdomain>
References: <20070505124954.0e2bcf53@localhost.localdomain>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 May 2007 12:49:54 +0200
Colin Leroy <colin@colino.net> wrote:

> Hi,
> 
> This patch changes the led brightness file's permissions to 0666, so that a 
> user's MUA can light up the mail LED without needing root permissions.

NAK.

The management of user specific temporary permissions belongs in user
space with a safe "no" default value to stop background daemons doing
silly things.

Take a look at the various pam console management modules (and also beat
people up to get revoke() support into the kernel).

Alan
