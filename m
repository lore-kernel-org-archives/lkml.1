Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbYGAIGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbYGAIGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbYGAIFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:05:45 -0400
Received: from styx.suse.cz ([82.119.242.94]:59128 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755839AbYGAIFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:05:42 -0400
Date: Tue, 1 Jul 2008 10:05:41 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>
cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] HID: fix quirk handling in usbmouse/kbd
In-Reply-To: <1214597365-21719-1-git-send-email-jirislaby@gmail.com>
Message-ID: <alpine.LNX.1.10.0807011005270.6375@jikos.suse.cz>
References: <1214597365-21719-1-git-send-email-jirislaby@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008, Jiri Slaby wrote:

> When usbmouse/kbd is set to build, USB_HID is never defined due to
> the USB_HID!=y Kconfig rule. Test CONFIG_USB_HID_MODULE in both
> drivers instead.

Hi Jiri,

good catch, applied, thanks a lot.

-- 
Jiri Kosina
SUSE Labs
