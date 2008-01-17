Return-Path: <linux-kernel-owner+w=401wt.eu-S1762265AbYAQWwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762265AbYAQWwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:52:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760488AbYAQWjC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:39:02 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:46309 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760479AbYAQWjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:39:00 -0500
Date: Thu, 17 Jan 2008 23:38:58 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Patrick J. LoPresti" <lopresti@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fast network file copy; "recvfile()" ?
In-Reply-To: <23986fd90801171253o56f3dbcbqe44d9f29e719cba1@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0801172337370.18447@fbirervta.pbzchgretzou.qr>
References: <23986fd90801171253o56f3dbcbqe44d9f29e719cba1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 17 2008 12:53, Patrick J. LoPresti wrote:

>Using 10GigE cards and the usual tweaks to tcp_rmem etc., I am
>getting single-stream TCP throughput better than 600 MB/sec.

Hm, be aware not to hit the sequence wrap :)

>1) O_DIRECT read() + send()
>2) mmap() + madvise(WILLNEED) + send()
>3) fadvise(WILLNEED) + sendfile()
>
>I am leaning towards (3), since I gather that sendfile() is supposed
>to be pretty fast.
>
>My question is what to do on the receiving end.  In short, if I want
>the equivalent of a "recvfile()" to go with sendfile(), what is my
>best bet on Linux?

splice() I think.
