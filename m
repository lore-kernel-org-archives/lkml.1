Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbZFDNQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbZFDNQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 09:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbZFDNQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 09:16:04 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60194 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbZFDNQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 09:16:03 -0400
To: goswin-v-b@web.de
CC: linux-kernel@vger.kernel.org, goswin-v-b@web.de
In-reply-to: <87d49k6h45.fsf@frosties.localdomain> (message from Goswin von
	Brederlow on Thu, 04 Jun 2009 01:18:50 +0200)
Subject: Re: include/linux/aio_abi.h and IOCB_CMD_POLL
References: <87d49k6h45.fsf@frosties.localdomain>
Message-Id: <E1MCCnb-0005Bc-09@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 04 Jun 2009 15:16:03 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Jun 2009, Goswin von Brederlow wrote:
> 3) Are there any alternatives to libaio that don't use threads and
>    support polling?

There are the poll, select and epoll interfaces that block, but are
able to multiplex events from many file descriptors.

And there's the O_ASYNC flag that can be set with an fcntl(), that
sends a SIGIO signal on an I/O event.

All of these work on /dev/fuse.

Thanks,
Miklos
