Return-Path: <linux-kernel-owner+w=401wt.eu-S1760449AbYDCJe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760449AbYDCJe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 05:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757143AbYDCJeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 05:34:20 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38172 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781AbYDCJeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 05:34:19 -0400
Date: Thu, 03 Apr 2008 18:34:00 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Andreas K. Huettel" <mail@akhuettel.de>
Subject: Re: [tainted,fglrx] page allocation failure: basic meaning of log messages?
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.1.00.0804031117030.10277@localhost>
References: <alpine.LNX.1.00.0804031117030.10277@localhost>
Message-Id: <20080403183021.028C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Apr  3 09:01:30 bellini hal-system-powe: page allocation failure. order:10, mode:0x4020
> Apr  3 09:01:30 bellini Pid: 327, comm: hal-system-powe Tainted: PF       2.6.24-gentoo-r3 #1
> Apr  3 09:01:30 bellini [<c0140c48>] __alloc_pages+0x2bd/0x2ce
> Apr  3 09:01:30 bellini [<c0140c92>] __get_free_pages+0x39/0x47
> Apr  3 09:01:30 bellini [<f8adcd9e>] firegl_cmmqs_save_fb+0x8e/0x200 [fglrx]

this messages doesn't mean bug, merely indicate allocation failure.
if any other bad thind doen't happend, you can ignore it.



