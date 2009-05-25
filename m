Return-Path: <linux-kernel-owner+w=401wt.eu-S1755108AbZEYXFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbZEYXFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 19:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbZEYXFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 19:05:21 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:48558 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbZEYXFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 19:05:21 -0400
MIME-Version: 1.0
In-Reply-To: <20090525223120.GC11648@ub>
References: <20090525205353.GB6856@redhat.com> <Pine.LNX.4.44L0.0905251704490.27717-100000@netrider.rowland.org> 
	<20090525214755.GE6856@redhat.com> <20090525223120.GC11648@ub>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 26 May 2009 01:05:00 +0200
Message-ID: <ac3eb2510905251605k5491f271q6432ccaef3e653fd@mail.gmail.com>
Subject: Re: 2.a.30-rc7: fat filesystem misdetected as amiga
To: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 00:31, Andries E. Brouwer
<Andries.Brouwer@cwi.nl> wrote:

> I can imagine that your device is a slow starter and needs some time
> to initialize itself, so that the first, or the first few, commands fail,
> and after that all is well.

Michael, what's the value of:
  /sys/module/usb_storage/parameters/delay_use
?

If that is less than 5 seconds, care to try if setting it to 5 makes
any difference?

Kay
