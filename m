Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbZDNORx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbZDNORx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 10:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbZDNORn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 10:17:43 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:35718 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262AbZDNORm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 10:17:42 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/4] cdc-acm: Fix long standing abuse of tty->low_latency
Date: Tue, 14 Apr 2009 16:18:04 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090414135501.13935.13500.stgit@t61.ukuu.org.uk> <20090414135728.13935.47954.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090414135728.13935.47954.stgit@t61.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904141618.05824.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 14 April 2009 15:57:36 schrieb Alan Cox:
> ACM sets the low latency flag but calls the flip buffer routines from IRQ
> context which isn't permitted (and as of 2.6.29 causes a warning hence this
> one was caught)
>
> Fortunatelt ACM doesn't need to set this flag in the first place as it only
> set it to work around problems in ancient (pre tty flip rewrite) kernels.

Very well, I am going to kill these in the USB serial drivers.

	Regards
		Oliver

