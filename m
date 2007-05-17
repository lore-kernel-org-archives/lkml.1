Return-Path: <linux-kernel-owner+w=401wt.eu-S1762177AbXEQAdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762177AbXEQAdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 20:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755702AbXEQAdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 20:33:42 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56205 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058AbXEQAdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 20:33:41 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <464BA28E.1020706@s5r6.in-berlin.de>
Date: Thu, 17 May 2007 02:32:14 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Al Viro <viro@ftp.linux.org.uk>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, zippel@linux-m68k.org,
       kbuild-devel@lists.sourceforge.net
Subject: Re: [RFC] select and dependencies in Kconfig
References: <E1Ho2om-0003TN-Ah@ZenIV.linux.org.uk> <20070516033335.GH4095@ftp.linux.org.uk> <464B141E.3020400@s5r6.in-berlin.de> <464B9427.1010204@freescale.com>
In-Reply-To: <464B9427.1010204@freescale.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi wrote:
> For example, if I want to add a new driver C that uses library B, I can
> just add this:
> 
> C
>     select B
> 
> If I have to use "depends on", then I would have to change the Kconfig
> option for B like this:
> 
> B
>     depends on A || C

You mean, "B... serves A, C".

However, it shouldn't matter which way around the dependencies are
written down in the Kconfigs.  What does matter is how "make
{old,menu,...}config" deal with it.
-- 
Stefan Richter
-=====-=-=== -=-= =---=
http://arcgraph.de/sr/
