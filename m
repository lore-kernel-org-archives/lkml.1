Return-Path: <linux-kernel-owner+w=401wt.eu-S932459AbXBSTQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbXBSTQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 14:16:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932487AbXBSTQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 14:16:07 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41486 "EHLO
	localhost.localdomain" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932459AbXBSTQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 14:16:06 -0500
Date: Mon, 19 Feb 2007 20:19:51 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Mockern@yandex.ru
Cc: linux-kernel@vger.kernel.org
Subject: Re: buffer overflows in the tty flip buffer in 2.6.17
Message-ID: <20070219201951.1ac6728d@localhost.localdomain>
In-Reply-To: <45D6F52B.000003.10185@webmail19.yandex.ru>
References: <45D6F52B.000003.10185@webmail19.yandex.ru>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> But how it is done in 2.6.17 linux kernel? I did check this "overflow code" in new tty driver's code. This code looks like just removed. But somehow overflow in the tty buffer must be kept.

The new tty layer manages memory allocation dynamically and handles
overflows itself. Just throw data at it and the right thing will occur in
current kernels.
