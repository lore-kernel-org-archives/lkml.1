Return-Path: <linux-kernel-owner+w=401wt.eu-S1762073AbYJEQo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762073AbYJEQo7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759491AbYJEQkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:40:17 -0400
Received: from senator.holtmann.net ([87.106.208.187]:54748 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761584AbYJEQkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:40:15 -0400
Subject: Re: [PATCH 02/19] pcmcia: IRQ_TYPE_EXCLUSIVE is long obsoleted
From: Marcel Holtmann <marcel@holtmann.org>
To: Alan Cox <alan@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081005163526.3799.57100.stgit@localhost.localdomain>
References: <20081005163302.3799.61899.stgit@localhost.localdomain>
	 <20081005163526.3799.57100.stgit@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 05 Oct 2008 18:40:31 +0200
Message-Id: <1223224831.11272.107.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

> Switch more drivers to dynamic sharing after checking their IRQ handlers
> use dev_id and are robust
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> ---
> 
>  drivers/bluetooth/bluecard_cs.c   |    2 +-
>  drivers/bluetooth/bt3c_cs.c       |    6 ++++--
>  drivers/bluetooth/btuart_cs.c     |    6 ++++--
>  drivers/bluetooth/dtl1_cs.c       |    7 +++++--
>  drivers/char/pcmcia/synclink_cs.c |    2 +-
>  drivers/parport/parport_cs.c      |    2 +-
>  6 files changed, 16 insertions(+), 9 deletions(-)
> 

Acked-by: Marcel Holtmann <marcel@holtmann.org>

I am fine if the changes for drivers/bluetooth/ go in via you.

Regards

Marcel


