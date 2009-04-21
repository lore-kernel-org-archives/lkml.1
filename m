Return-Path: <linux-kernel-owner+w=401wt.eu-S1752972AbZDUN0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbZDUN0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 09:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbZDUN0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 09:26:37 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:42505 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947AbZDUN0g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 09:26:36 -0400
From: Oliver Neukum <oliver@neukum.org>
To: =?utf-8?q?Mar=C3=B3y_=C3=81kos?= <akos@maroy.hu>,
       linux-usb@vger.kernel.org
Subject: Re: cdc-acm driver hangs on poll() call - 2.6.27, works on 2.6.24
Date: Tue, 21 Apr 2009 15:26:33 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.29-9-default; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <49EDC44D.90106@maroy.hu>
In-Reply-To: <49EDC44D.90106@maroy.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904211526.34199.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 21 April 2009 15:04:13 schrieb Maróy Ákos:
> and it just hangs there forever.
>
> from the kernel changelog, I saw there were changes made to the cdc-acm
> mobule between 2.6.24 and 2.6.27. might those changes by in relation to
> the above effect?
>
> any help is appreciated...

Does it happen with 2.6.29?
Could you get dmesg of 2.6.2(7/9) with CONFIG_USB_DEBUG and debug
activated in drivers/usb/class/cdc-acm.c ?

	Regards
		Oliver

