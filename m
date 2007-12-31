Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbXLaQAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbXLaQAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 11:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbXLaQAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 11:00:25 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:50783 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbXLaQAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 11:00:24 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Subject: Re: [PATCH] Force UNIX domain sockets to be built in
Date: Mon, 31 Dec 2007 16:59:14 +0100
User-Agent: KMail/1.9.6
Cc: "Adrian Bunk" <bunk@kernel.org>, "Bodo Eggert" <7eggert@gmx.de>,
       "Jan Engelhardt" <jengelh@computergmbh.de>, devzero@web.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <alpine.LSU.0.999.0712311300020.3686@be1.lrz> <20071231144255.GB13803@does.not.exist> <64bb37e0712310755k2446e67eq81d31cd476eb75e3@mail.gmail.com>
In-Reply-To: <64bb37e0712310755k2446e67eq81d31cd476eb75e3@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712311659.14847.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 December 2007 16:55:57 Torsten Kaiser wrote:
> On Dec 31, 2007 3:42 PM, Adrian Bunk <bunk@kernel.org> wrote:
> > With CONFIG_MODULES=y the 13 EXPORT_SYMBOL's that only exist for the
> > theoretical possibility of CONIG_UNIX=m waste a few hundred bytes
> > of memory.
> 
> One thing I always wondered about in this discussion about wasted
> EXPORT_SYMBOL's:
> Shouldn't it be possible to garbage collect these?
> 
> depmod already contains code to analyze all modules to create a
> dependency tree. It should not be too difficult to extend it to create
> a list of all symbols that really are used by the current modules.
> Everything else could be stripped to save space.
> 
> The problem with that:
> * out-of-tree modules would break if they don't get lucky to only use
> the remaining symbol. I would not see this as a problem, if the help
> text of the garbage-collect-option would contain a note like "don't
> enable this if you want out-of-tree modules".
> * if you later change your .config to include additional modules you
> might need to rebuild vmlinux and reboot into the new kernel.
> Currently you can probably build and load new modules without a
> reboot. (for example: usb drivers)

I'd say the practical advantage to the user would be almost zero.
Which distribution is going to enable this option and defacto
banning external modules?

-- 
Greetings Michael.
