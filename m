Return-Path: <linux-kernel-owner+w=401wt.eu-S1760267AbYEKXUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760267AbYEKXUx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 19:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757448AbYEKXUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 19:20:45 -0400
Received: from senator.holtmann.net ([87.106.208.187]:59484 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727AbYEKXUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 19:20:44 -0400
Subject: Re: [PATCH 3/9] HID: hid, make parsing event driven
From: Marcel Holtmann <marcel@holtmann.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       anssi.hannula@gmail.com, akpm@linux-foundation.org,
       Jiri Slaby <jslaby@suse.cz>
In-Reply-To: <1210536043-19812-3-git-send-email-jirislaby@gmail.com>
References: <1210536043-19812-1-git-send-email-jirislaby@gmail.com>
	 <1210536043-19812-2-git-send-email-jirislaby@gmail.com>
	 <1210536043-19812-3-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain
Date: Mon, 12 May 2008 01:20:50 +0200
Message-Id: <1210548050.16390.39.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> Next step for complete hid bus, this patch includes:
> - call parser either from probe or from hid-core if there is no probe.
> - add ll_driver structure and centralize some stuff there (open, close...)
> - split and merge usb_hid_configure and hid_probe into several functions
>   to allow hooks/fixes between them

has the Bluetooth HIDP changes been tested. You move a lot of code
around and this might have side effects.

Regards

Marcel


