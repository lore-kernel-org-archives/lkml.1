Return-Path: <linux-kernel-owner+w=401wt.eu-S1759550AbXEMRKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759550AbXEMRKQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 13:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755962AbXEMRKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 13:10:06 -0400
Received: from main.gmane.org ([80.91.229.2]:51087 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbXEMRKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 13:10:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Nikita V. Youshchenko" <yoush@debian.org>
Subject: Re: [PATCH] allow kernel module exclusion on load
Date: Sun, 13 May 2007 21:05:34 +0400
Message-ID: <1216096.ezegMODXOY@yoush.homelinux.org>
References: <20070513132517.GA14038@localdomain> <20070513092352.18cd80de@freepuppy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: ppp20-232.pppoe.mtu-net.ru
User-Agent: KNode/0.10.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> On Sun, 13 May 2007 16:25:17 +0300
> Dan Aloni <da-x@monatomic.org> wrote:
> 
>> Kernel developers might find it useful for quickly getting out from some
>> rough debugging scenarios.
>> 
>> Signed-off-by: Dan Aloni <da-x@monatomic.org>
>> 
> 
> There is already the modprobe blacklist ability in user space.

I guess the patch being discussed could still save some time for people who
try or debug a new kernel and find that certain module crashes it. Yes it
is possible to boot to old kernel, then blacklist something, then
regenerate initramfs, etc etc, and then undo all that.

Compared to that, adding a boot arg to kernel being debugged is *much* more
convinient.

Just my 2c.

