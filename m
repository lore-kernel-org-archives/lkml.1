Return-Path: <linux-kernel-owner+w=401wt.eu-S1758198AbXERRyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198AbXERRyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 13:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbXERRyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 13:54:31 -0400
Received: from quechua.inka.de ([193.197.184.2]:54046 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742AbXERRyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 13:54:31 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: ht CPU flag
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <Pine.LNX.4.64.0705182131030.25685@ns.armcci.am>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1Hp6er-0001aX-00@calista.eckenfels.net>
Date: Fri, 18 May 2007 19:54:29 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <Pine.LNX.4.64.0705182131030.25685@ns.armcci.am> you wrote:
> I have Pentium D CPU, which many Windows utilities like cpuz, wcpuid, 
> everest identify as D 930 (Dual Core, 3GHz). From Intel site I find out 
> that it has no HT feature, nor Windows XP identify it as HT.

the ht flag reported by the CPU and cpuinfo is not a reliable detection if
HT is available on your CPU or your motherboard/bios.

> Why do I have "ht" flag in cpuinfo?

Because your CPU reports it. You will see that also in cpuz output.

However, you can see ht in the sibblings value (for a single core it will be
2 if you have HT, I am not sure if it is 4 for a dual core CPU)

Gruss
Bernd
