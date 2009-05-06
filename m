Return-Path: <linux-kernel-owner+w=401wt.eu-S1759620AbZEFMcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620AbZEFMcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbZEFMbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:31:51 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:36122 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbZEFMbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:31:50 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 1/5] usb_debug: implement multi urb write
Date: Wed, 6 May 2009 14:31:56 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1241575205-12199-1-git-send-email-jason.wessel@windriver.com> <200905060916.56384.oliver@neukum.org> <4A017B2B.1050906@windriver.com>
In-Reply-To: <4A017B2B.1050906@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905061431.56638.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 6. Mai 2009 13:57:31 schrieb Jason Wessel:

> I would agree with you on that.  It also means that the ftdi_sio.c
> driver has the same bug, because that is where it was derived from.  You

Greg will happily take a patch.

> led me to see another flaw upon further inspection in that the usb_debug
> driver must also implement the chars_in_buffer() call back because the
> generic serial code will cause an oops with a null pointer dereference
> of the write_urb.

Good.

	Regards
		Oliver

