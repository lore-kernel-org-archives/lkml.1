Return-Path: <linux-kernel-owner+w=401wt.eu-S1752110AbZKLKLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbZKLKLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 05:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbZKLKLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 05:11:52 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:36232 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbZKLKLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 05:11:51 -0500
MIME-Version: 1.0
In-Reply-To: <20091112095544.GF8742@kernel.dk>
References: <bd36f99e0911110118v6dc7f87ao98968ba234fad7fc@mail.gmail.com>
	 <4AFA835B.9000904@garzik.org>
	 <bd36f99e0911110412hf2c7920gf06bd29ed43e240c@mail.gmail.com>
	 <bd36f99e0911111309ie8166a9h8f926948bf15d350@mail.gmail.com>
	 <4AFB2F2A.7080900@garzik.org> <20091112091602.GC8742@kernel.dk>
	 <bd36f99e0911120148t43a267cbwd1899d3e68468cc@mail.gmail.com>
	 <20091112095544.GF8742@kernel.dk>
Date: Thu, 12 Nov 2009 05:11:56 -0500
Message-ID: <bd36f99e0911120211h2bda5062qe90d7be56203523@mail.gmail.com>
Subject: Re: Crash during SATA reads
From: Glenn Maynard <glenn@zewt.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 4:55 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> To rule out any potential hardware problems, have you run any extensive
> memory checks on this machine?

God damn it.  I ran memtest+ just a week or so ago and it was fine
through several passes; now it's failing badly.  I'm inclined to send
Kingston a bill for a day and a half of wasted time.

I didn't think back to memory since I'm used to memory problems in
userspace, where they cause wildly variable crashes.  Of course, the
kernel's far more likely to stick data in the same spot, so it makes
sense that it doesn't cause as much volatility, leading to a bunch of
related-looking crashes.

Thanks.

-- 
Glenn Maynard
