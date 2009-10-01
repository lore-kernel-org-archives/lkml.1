Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbZJAVJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbZJAVJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 17:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbZJAVJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 17:09:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37530 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752000AbZJAVJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 17:09:24 -0400
Date: Thu, 1 Oct 2009 22:10:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Breno Leitao <leitao@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jsm: fixing termios structure to be compatible with
 stty application
Message-ID: <20091001221038.4457e8d6@lxorguk.ukuu.org.uk>
In-Reply-To: <4AC51244.1010600@linux.vnet.ibm.com>
References: <1254327512-6880-1-git-send-email-leitao@linux.vnet.ibm.com>
	<20090930213140.4172748f@lxorguk.ukuu.org.uk>
	<4AC51244.1010600@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hence, I just assigned ospeed and ispeed with the requested speed in Bfoo
> format (c_flag & CBAUD).

The kernel ospeed and ispeed are not in Bfoo format, they are actual bit
rates. (I've no idea what glibc does, last time I checked it didn't even
support 2007 era Linux speed setting properly so apps still have to use
ioctls directly for them)

> 
> I also tested the tty_termios_encode_baud_rate(), and it will basically do what
> I did:
> 
>         termios->c_ispeed = ibaud;
>         termios->c_ospeed = obaud;
> 
> Thanks for the review, and sorry if I missed the point completely.

ibaud != Bfoo

