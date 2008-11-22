Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbYKVJOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbYKVJOb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 04:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYKVJOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 04:14:18 -0500
Received: from ox1.aei.mpg.de ([194.94.224.6]:46416 "EHLO ox1.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbYKVJOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 04:14:16 -0500
Date: Sat, 22 Nov 2008 10:14:39 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Andrey Vul <andrey.vul@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.27.6] error: missing symbol in drivers/net/r8169
Message-ID: <20081122091438.GA19952@localhost.aei.mpg.de>
References: <e38d12ff0811211914o5937f2cek84b9bbb570f7b4b6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e38d12ff0811211914o5937f2cek84b9bbb570f7b4b6@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri 21.Nov'08 at 22:14:57 -0500, Andrey Vul wrote:
> output of make | tail:
>  Building modules, stage 2.
>   MODPOST 107 modules
> ERROR: "mii_ethtool_gset" [drivers/net/r8169.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2


Try 2.6.27.7, it is fixed there:

http://lkml.org/lkml/2008/11/21/461

