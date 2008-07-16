Return-Path: <linux-kernel-owner+w=401wt.eu-S1758270AbYGPPo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270AbYGPPo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 11:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756505AbYGPPoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 11:44:16 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:52321 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135AbYGPPoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 11:44:15 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH] drivers/usb/class/usblp.c: adjust error handling code
Date: Wed, 16 Jul 2008 17:44:58 +0200
User-Agent: KMail/1.9.9
Cc: zaitcev@redhat.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0807161717220.28783@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0807161717220.28783@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807161744.59137.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 16 Juli 2008 17:17:42 schrieb Julia Lawall:
> From: Julia Lawall <julia@diku.dk>
> 
> In this code, it is possible to tell statically whether usblp will be NULL
> in the error handling code.
> 
> Another option would have been to put a label directly on the return.

That would be better. It means less chance to overlook an error case
if locking needs to be added in the future.

	Regards
		Oliver

