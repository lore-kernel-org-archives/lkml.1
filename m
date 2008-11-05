Return-Path: <linux-kernel-owner+w=401wt.eu-S1757158AbYKEAaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158AbYKEAaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 19:30:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbYKEA36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 19:29:58 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:50150 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbYKEA35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 19:29:57 -0500
Message-ID: <ac3eb2510811041629x152712ddwa43a048169b1e233@mail.gmail.com>
Date: Wed, 5 Nov 2008 01:29:54 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Michael Tokarev" <mjt@tls.msk.ru>
Subject: Re: data corruption: revalidating a (removable) hdd/flash on re-insert
Cc: "Pavel Machek" <pavel@suse.cz>,
       "Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <4910BD2B.1020808@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <490B2659.9010304@msgid.tls.msk.ru>
	 <ac3eb2510810310910w603d90bai8c23b34fb517f21a@mail.gmail.com>
	 <20081104195728.GC5862@ucw.cz>
	 <ac3eb2510811041213l4a20fa12h3c5beb3c2d317574@mail.gmail.com>
	 <20081104202011.GA7135@ucw.cz> <4910BD2B.1020808@msgid.tls.msk.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2008 at 22:22, Michael Tokarev <mjt@tls.msk.ru> wrote:

> So for me, it's easy to deal with (not perfect but it works; it'd be
> even better if i will be able to wait for umount using inotify, to
> only wake when really needed),

If I understand it right, what you are looking for, you could sleep in
poll() of /proc/mounts, and will be woken up with POLLERR if anything
in your mount tree changes. Then you check the state of your usb
device and possibly invalidate it.

Kay
