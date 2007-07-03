Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbXGCGov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbXGCGov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 02:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbXGCGoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 02:44:44 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:44587 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbXGCGoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 02:44:44 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] NIKON D50 problem
Date: Tue, 3 Jul 2007 08:44:41 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, "Ni@m" <niam.niam@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <a9e22dff0707021217r239ebcf0g8154a6e985b078f3@mail.gmail.com> <20070702155912.fe1e6834.akpm@linux-foundation.org>
In-Reply-To: <20070702155912.fe1e6834.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707030844.42119.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> It's more likely a usb-storage or scsi layer problem.
> 
> The device reports as having 1984001 sectors and the kernel is reporting IO
> errors around the very end of the device.  Presumably an IO is straddling
> end-of-device and we're not handling that correctly.

Can you try the work around suggested here:

https://lists.one-eyed-alien.net/pipermail/usb-storage/2007-June/003053.html> 

	Regards
		Oliver
