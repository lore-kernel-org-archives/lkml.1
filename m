Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbYDVODa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbYDVODa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 10:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbYDVODV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 10:03:21 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:34250 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751031AbYDVODT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 10:03:19 -0400
Date: Tue, 22 Apr 2008 23:03:18 +0900 (JST)
Message-Id: <20080422.230318.112756414.taka@valinux.co.jp>
To: jens.axboe@oracle.com, agk@sourceware.org
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/10] I/O context inheritance
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <20080422.224935.00673711.taka@valinux.co.jp>
References: <20080422.224935.00673711.taka@valinux.co.jp>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry, these patches are for linux-2.6.25.

> This series of patches make the block I/O layer and the I/O schedulers
> be able to determine the right io_context of every I/O.
> 
> The current implementation of the block I/O layer and the I/O schedulers
> assume that the current process is the one which issued the given I/O,
> then use the io_context of this process to control the I/O.
> But this assumption isn't quite right because several kernel threads
> will handle I/O requests on behalf of the processes which originated them.
> This often happens when you want to use device mapper modules.
> 
> The patches make every bio has a pointer to an io_context, which will
> be set when it is allocated or cloned. So it makes it possible to find
> the right io_context from any bio at any place.
> 
> I'm waiting for your comments.
> 
> Thank you,
> Hirokazu Takahashi.
