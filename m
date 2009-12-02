Return-Path: <linux-kernel-owner+w=401wt.eu-S1755740AbZLBVli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbZLBVli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 16:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbZLBVlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 16:41:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755313AbZLBVlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 16:41:36 -0500
Date: Wed, 2 Dec 2009 13:40:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ondrej Zary <zary@gsystems.sk>
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       daniel.ritz@gmx.ch, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] [resend] usbtouchscreen: convert from usb_device to
 usb_interface
Message-Id: <20091202134053.4eb5f8dc.akpm@linux-foundation.org>
In-Reply-To: <200911301306.43364.zary@gsystems.sk>
References: <200911301306.43364.zary@gsystems.sk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009 13:06:41 +0100
Ondrej Zary <zary@gsystems.sk> wrote:

> Convert usbtouchscreen from storing usb_device to usb_interface. This is
> needed for multi-interface touchscreen devices such as iNexio.

There are some pretty large changes to
drivers/input/touchscreen/usbtouchscreen.c in linux-next which cause
these patches to not apply.  And possibly to not work correctly.

