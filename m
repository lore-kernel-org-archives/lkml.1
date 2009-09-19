Return-Path: <linux-kernel-owner+w=401wt.eu-S1752404AbZISTSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbZISTSB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 15:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbZISTSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 15:18:00 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:45822 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbZISTSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 15:18:00 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Kevin Cernekee <cernekee@gmail.com>
Subject: Re: [PATCH] kaweth: Fix memory leak in kaweth_control()
Date: Sat, 19 Sep 2009 21:19:37 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc9-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
References: <6a1f935a6229adafb68d0e1ca7bc71fa@localhost>
In-Reply-To: <6a1f935a6229adafb68d0e1ca7bc71fa@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909192119.37988.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 19. September 2009 03:43:30 schrieb Kevin Cernekee:
> kaweth_control() never frees the buffer that it allocates for the USB
> control message.  Test case:
>
> while :; do ifconfig eth2 down ; ifconfig eth2 up ; done
>
> This is a tiny buffer so it is a slow leak.  If you want to speed up the
> process, you can change the allocation size to e.g. 16384 bytes, and it
> will consume several megabytes within a few minutes.

You are right, the patch is correct. But it has to go to netdev, as it
is for a network driver. Please resend it and add
Acked-by: Oliver Neukum <oliver@neukum.org>

Greg, it should go into stable, too.

	Regards
		Oliver

