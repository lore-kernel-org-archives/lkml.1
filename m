Return-Path: <linux-kernel-owner+w=401wt.eu-S1031249AbXDJRd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031249AbXDJRd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 13:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031267AbXDJRdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 13:33:55 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36387 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031249AbXDJRdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 13:33:54 -0400
Date: Tue, 10 Apr 2007 18:36:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Egmont Koblinger <egmont@uhulinux.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
Message-ID: <20070410183659.7341eeec@the-village.bc.nu>
In-Reply-To: <20070410171924.GA18314@uhulinux.hu>
References: <20070406191245.GA11974@uhulinux.hu>
	<4616A2C7.3030000@zytor.com>
	<20070407092451.GA8779@uhulinux.hu>
	<Pine.LNX.4.61.0704071232560.22181@yvahk01.tjqt.qr>
	<20070407172603.GA25351@uhulinux.hu>
	<4617DBF7.5060009@zytor.com>
	<20070410094325.GB9143@uhulinux.hu>
	<461BB092.3070201@zytor.com>
	<20070410171924.GA18314@uhulinux.hu>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> What do you exactly mean by this? Doing a binary search in a table of 11
> intervals to find out whether a character is double-wide? Adding
> approximately 30 lines of code (including the table and the binary search
> routine) to the kernel to handle this case? I don't think it's bloat. It's a

I don't have a problem with it. It is a situation people find themselves
in and framebuffer consoles can handle CJK although PC text mode ones
can't do it well. It all comes down to a clean and small implementation.

Alan
