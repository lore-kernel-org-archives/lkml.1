Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbYKPQUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbYKPQUJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 11:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbYKPQTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 11:19:55 -0500
Received: from mail.suse.de ([195.135.220.2]:48430 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbYKPQTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 11:19:54 -0500
Date: Sun, 16 Nov 2008 17:19:52 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, x86@kernel.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       crash-utility@redhat.com
Subject: Re: Turn CONFIG_STRICT_DEVMEM in sysctl dev.mem.restricted
Message-ID: <20081116171952.632947a7@kopernikus.site>
In-Reply-To: <20081116080342.3d6c6976@infradead.org>
References: <1226846868-9595-1-git-send-email-bwalle@suse.de>
	<20081116150756.3cece2de@lxorguk.ukuu.org.uk>
	<20081116162003.04267538@kopernikus.site>
	<20081116154541.1f196f1e@lxorguk.ukuu.org.uk>
	<20081116080342.3d6c6976@infradead.org>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven [2008-11-16 08:03]:

> 
> the point of the /dev/mem restrictions is to not allow things you know
> you don't need, while still allowing X to function where it can access
> the crap it does. Now in Bernhard's case he DOES need them, so he
> shouldn't use the restrictions.

Right. But shipping two kernel images is a bit too much to turn a
restriction on or off. Get away from that "recompile your kernel".

But I get more and more convinced that we really want to just turn that
configuration option off. I'm no expert in security, and at some point,
I just have to believe what people write.


Regards,
Bernhard
