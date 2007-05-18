Return-Path: <linux-kernel-owner+w=401wt.eu-S1756573AbXERUc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbXERUc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 16:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbXERUcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 16:32:51 -0400
Received: from quechua.inka.de ([193.197.184.2]:57599 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbXERUcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 16:32:50 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Cc: eugene@ns.armcci.am
Subject: Re: ht CPU flag
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <Pine.LNX.4.64.0705190023420.25685@ns.armcci.am>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1Hp982-0002Mp-00@calista.eckenfels.net>
Date: Fri, 18 May 2007 22:32:46 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <Pine.LNX.4.64.0705190023420.25685@ns.armcci.am> you wrote:
> Am I right that is chipset on mainboard, who is saying - "I know....", not 
> CPU itself?

It is a feature bitfield read directly from the CPU.

> Is it better to switch off HT support in BIOS?

The CPU will still report that flag. Might speed up the boot, not sure.

> Is it possible to generate CPU name as: "Pentium D 930" in /proc/cpuinfo?

No, cause those are marketing names, not reported by the CPU. You can only
lookup family, model and stepping with the vendors data sheets to get a
first impression of the possible chip.

Some chip cores get reconfigured by the vendor depending on QA (if it is not
able to cleanly process at high speed it gets sold as a slower chip).

> On the other server I have some 2GHz HT Xeons which can't be identified on 
> Intel site because of strange naming pattern.

Google for model and stepping.

Gruss
Bernd
