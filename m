Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbZEYUlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbZEYUlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 16:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZEYUlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 16:41:31 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:54230 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbZEYUlb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 16:41:31 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0905251621320.26833-100000@netrider.rowland.org>
References: <20090525184816.GB6649@redhat.com> <Pine.LNX.4.44L0.0905251621320.26833-100000@netrider.rowland.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 25 May 2009 22:41:11 +0200
Message-ID: <ac3eb2510905251341j41493d44ta814018cede2df8c@mail.gmail.com>
Subject: Re: 2.a.30-rc7: fat filesystem misdetected as amiga
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 22:37, Alan Stern <stern@rowland.harvard.edu> wrote:

> As far as I can tell, this has nothing to do with any user programs in
> the distribution.  It appears to be entirely the device's fault.

Sounds good. Maybe we can just double-check.

Michael, if you do:
  killall udevd
do you see the same issue when connecting the device?

That would tell us if some userspace tool is involved here, which
hooks into the udev events.

You can just start udev again by:
  udevd -d

Thanks,
Kay
