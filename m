Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab0BWBxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 20:53:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:60244 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab0BWBxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 20:53:43 -0500
Date: Mon, 22 Feb 2010 17:55:29 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: Len Brown <lenb@kernel.org>, Wojciech Ploskonka <wploskonka@gmail.com>,
       thomas@archlinux.org, Andrew Morton <akpm@linux-foundation.org>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
       mie.iscrizioni@gmail.com
Subject: Re: High cpu temperature with 2.6.32, bisection shows commit 69d258
 (fwd)
Message-ID: <20100222175529.13ae0565@infradead.org>
In-Reply-To: <alpine.LNX.2.00.1002221836060.15882@localhost.localdomain>
References: <alpine.LNX.2.00.1001071941470.1363@localhost.localdomain>
	<20100108171513.GB22713@ldl.fc.hp.com>
	<20100109134352.3dedd4ea@infradead.org>
	<alpine.LNX.2.00.1001100155370.1325@localhost.localdomain>
	<20100109160836.26a344a9@infradead.org>
	<alpine.LNX.2.00.1001100226570.1325@localhost.localdomain>
	<20100109164240.43b21247@infradead.org>
	<alpine.LNX.2.00.1001100251210.1334@localhost.localdomain>
	<20100112160734.89ee6b11.akpm@linux-foundation.org>
	<20100112213205.7d74808a@infradead.org>
	<alpine.LNX.2.00.1002102245200.1675@localhost.localdomain>
	<20100210205637.63131c24@infradead.org>
	<alpine.LNX.2.00.1002111929300.1668@localhost.localdomain>
	<4B747D7D.2070002@gmail.com>
	<20100211212415.2eace0c2@infradead.org>
	<alpine.LNX.2.00.1002221836060.15882@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Feb 2010 18:43:50 +0200 (EET)
Dimitrios Apostolou <jimis@gmx.net> wrote:

> Hi Arjan, Len,
> 
> It seems that another user of archlinux (mie.iscrizioni CC'd) is
> having the same problem, and this time I can't see any PME+ flag in
> lspci output. The bug report is at [1] but since it's getting too big
> perhaps you want to take a look at attachment [2], which includes
> "powertop -d", "dmidecode" and "lspci -vvv" output.
> 
> BTW, the common denominator for all these cases is the message
> "Marking TSC unstable due to TSC halts in idle". So I was thinking
> perhaps the code that detects the bug is already there! What do you
> think?

every single Intel and AMD cpu prior to the latest generation will spew
that message....
