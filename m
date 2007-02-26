Return-Path: <linux-kernel-owner+w=401wt.eu-S1030412AbXBZShf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030412AbXBZShf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 13:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030405AbXBZShf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 13:37:35 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42142 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751291AbXBZShe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 13:37:34 -0500
Date: Mon, 26 Feb 2007 19:41:31 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Zach Brown <zab@zabbo.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de
Subject: Re: [RFC/PATCH] revokeat/frevoke system calls V5
Message-ID: <20070226194131.2c4e4a47@lxorguk.ukuu.org.uk>
In-Reply-To: <79B7BBDC-E953-4EAE-8D32-E510DE0981FF@zabbo.net>
References: <Pine.LNX.4.64.0701282200450.17167@sbz-30.cs.Helsinki.FI>
	<20070226003307.6f38d2ee@lxorguk.ukuu.org.uk>
	<84144f020702252325j29da2819i50c99477cce89359@mail.gmail.com>
	<45E291F7.6060508@zytor.com>
	<79B7BBDC-E953-4EAE-8D32-E510DE0981FF@zabbo.net>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not sure.  Turning, for example, the statat(dir_fd, name == NULL)  
> error case into fstat(dir_fd) sounds like a way for apps, admittedly  
> buggy ones, to be surprised.  Maybe libc would be exptected to catch  
> the error before performing the shared system call?

At that point would it not be cheaper to have two system calls, the table
cost isn't very large.
