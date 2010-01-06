Return-Path: <linux-kernel-owner+w=401wt.eu-S932804Ab0AFU7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804Ab0AFU7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 15:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932565Ab0AFU7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 15:59:14 -0500
Received: from senator.holtmann.net ([87.106.208.187]:41330 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab0AFU7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 15:59:12 -0500
Subject: Re: [PATCH] DFU Driver for Atheros bluetooth chipset AR3011
From: Marcel Holtmann <marcel@holtmann.org>
To: Kandukuri Vikram <vkandukuri@atheros.com>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
       lrodriguez@atheros.com
In-Reply-To: <20100106133415.GC13153@atheros-laptop>
References: <20100106133415.GC13153@atheros-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jan 2010 12:57:56 -0800
Message-ID: <1262811476.16627.402.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vikram,

> Signed-off-by: Vikram Kandukuri <vikram.kandukuri@atheros.com>
> Signed-off-by: Alicke Xu <sxu@atheros.com>
> Reviewed-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/bluetooth/Kconfig  |   13 +++-
>  drivers/bluetooth/Makefile |    1 +
>  drivers/bluetooth/ath3k.c  |  187 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 200 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/bluetooth/ath3k.c

patch has been applied to my trees.

However I still had to hand edit in various small ares. For example
BT_DBG doesn't require the \n newline. So you have never actually tested
the debug code. Otherwise you would have seen that something is off.
Also there were still a bunch of spaces in the code that I had to fix
manually.

Also I prefer if you a bit more consistent writing "Bluetooth" exactly
this way in comment and descriptions. It is brand name and the writing
is suppose to be consistent.

Regards

Marcel


