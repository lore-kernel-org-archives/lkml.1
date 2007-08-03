Return-Path: <linux-kernel-owner+w=401wt.eu-S1758997AbXHCGVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997AbXHCGVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 02:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbXHCGUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 02:20:54 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:49883 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052AbXHCGUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 02:20:54 -0400
Date: Fri, 3 Aug 2007 08:24:37 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: eurotechwdt will cause reboot
Message-ID: <20070803062436.GA2652@infomag.infomag.iguana.be>
References: <a8e1da0707312003s6000b02s95c90b5971dbbd51@mail.gmail.com> <20070801055845.GA2648@infomag.infomag.iguana.be> <a8e1da0707312322g4559a546xc357505b591f9e65@mail.gmail.com> <a8e1da0708021853y1eab0ee1v859ffdb9b35762a2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0708021853y1eab0ee1v859ffdb9b35762a2@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> Hi,
> News: 2.6.23-rc1-mm1 will reboot with eurotechwdt, but 2.6.23-rc1-mm2
> will not. do you need the config files?
> 
> I will concentrate on this problem as well. Any hints how to debug?

Yes: make a diff file between the two versions and see what has changed.
If something changed on the eurotechwdt file then that is probably the
answer you are looking for.  Else it will mean that your problem is fixed
by other code and then we will have to find out which code did this.

I was reading the datasheet to see how the driver worked. But I think
we want to concentrate now first on what the difference is between the
-mm1 and -mm2. Luckily something fixed allready your problem. Now it would
be usefull to know what that was.

Are your config files for both versions almost the same?

Greetings,
Wim.
