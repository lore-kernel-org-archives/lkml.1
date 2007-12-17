Return-Path: <linux-kernel-owner+w=401wt.eu-S935417AbXLQKxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935417AbXLQKxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 05:53:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763452AbXLQKwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 05:52:53 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37540 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752363AbXLQKww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 05:52:52 -0500
Date: Mon, 17 Dec 2007 02:52:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: jurriaan <thunder7@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jikos@jikos.cz>
Subject: Re: 2.6.24-rc5-mm1 compile failure: usbhid_lookup_quirk
Message-Id: <20071217025238.252f3e89.akpm@linux-foundation.org>
In-Reply-To: <20071215185040.GA32609@amd64.of.nowhere>
References: <20071215185040.GA32609@amd64.of.nowhere>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Dec 2007 19:50:40 +0100 jurriaan <thunder7@xs4all.nl> wrote:

>   MODPOST 196 modules
>   ERROR: "usbhid_lookup_quirk" [drivers/hid/usbhid/usbmouse.ko]
>   undefined!
>   ERROR: "usbhid_lookup_quirk" [drivers/hid/usbhid/usbkbd.ko] undefined!
>   make[1]: *** [__modpost] Error 1
>   make: *** [modules] Error 2
> 
> The problem was fixed by defining CONFIG_USB_HID=m - but I think that
> should happen automatically if it is necessary.
> 
> .config was created by running make oldconfig against 2.6.23-rc8-mm2:

Thanks.  That's coming out of git-hid.patch.
