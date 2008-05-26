Return-Path: <linux-kernel-owner+w=401wt.eu-S1757187AbYEZO5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbYEZO5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 10:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbYEZO5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 10:57:38 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:38727 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbYEZO5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 10:57:37 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] usblcd: Push down BKL into driver
Date: Mon, 26 May 2008 16:57:40 +0200
User-Agent: KMail/1.9.9
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080522220751.599d73ee@core>
In-Reply-To: <20080522220751.599d73ee@core>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805261657.41398.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 22 Mai 2008 23:07:51 schrieb Alan Cox:
> I'm pretty sure this can be eliminated however I couldn't prove (or find)
> what stopped the device vanishing mid IOCTL_GET_HARD_VERSION. Perhaps a
> USB wizard could double check that and see if the lock_kernel can go
> entirely.

Nothing does. The driver is buggy as it is now irrespective of BKL.
Thanks for noticing.

	Regards
		Oliver
