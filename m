Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbZDUNjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbZDUNjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 09:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbZDUNj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 09:39:26 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:38578 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbZDUNjZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 09:39:25 -0400
From: Oliver Neukum <oliver@neukum.org>
To: =?utf-8?q?Mar=C3=B3y_=C3=81kos?= <akos@maroy.hu>
Subject: Re: cdc-acm driver hangs on poll() call - 2.6.27, works on 2.6.24
Date: Tue, 21 Apr 2009 15:39:23 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.29-9-default; KDE/4.1.3; x86_64; ; )
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <49EDC44D.90106@maroy.hu> <200904211526.34199.oliver@neukum.org> <49EDCB0F.3040802@maroy.hu>
In-Reply-To: <49EDCB0F.3040802@maroy.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904211539.23671.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 21 April 2009 15:33:03 schrieb Maróy Ákos:
> Oliver,
>
> > Does it happen with 2.6.29?
>
> haven't tried yet. I'm just upgrading to ubuntu 9.04, which has 2.6.28
> built in.
>
> I also see cdc-acm fixes in the 2.6.28 Changelog, like:
>
> USB: gadget: cdc-acm deadlock fix

That's gadget code. Your problem is on the host's side.

>
> > Could you get dmesg of 2.6.2(7/9) with CONFIG_USB_DEBUG and debug
> > activated in drivers/usb/class/cdc-acm.c ?
>
> ok, let me upgrade to 2.6.28 first, and if the proplem still persists,
> I'll compile 2.6.29 with the above settings manually.

Thanks.

	Regards
		Oliver

