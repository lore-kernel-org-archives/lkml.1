Return-Path: <linux-kernel-owner+w=401wt.eu-S1758051AbXFDUvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbXFDUvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 16:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbXFDUvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 16:51:15 -0400
Received: from il.qumranet.com ([82.166.9.18]:44703 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649AbXFDUvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 16:51:14 -0400
Message-ID: <46647B3E.2090205@qumranet.com>
Date: Mon, 04 Jun 2007 23:51:10 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [BUG] Oops with KVM-27
References: <20070603213432.GA3075@dreamland.darkstar.lan> <4663DCE9.3000107@qumranet.com> <20070604202248.GA18668@dreamland.darkstar.lan>
In-Reply-To: <20070604202248.GA18668@dreamland.darkstar.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Mon, 04 Jun 2007 23:51:11 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luca Tettamanti wrote:
> It turned out that it was somewhat reproducible with fedora installer.
> With your patch it doesn't oops anymore.
>
>   

Ok, good.

> While doing repeated tests with the installer I ran into another
> (unrelated) problem. Sometimes the guest kernel hangs at boot at:
>
> NET: Registered protocol family 2
>
> with any kind of networking options (except for -net none, which works).
> With -no-kvm it boots with any networking option.
>
>   

Can you try to pin the guest on a single core with taskset:

   taskset 1 qemu ...

?

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

