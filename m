Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816Ab0BLVGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 16:06:01 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:32860 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757710Ab0BLVF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 16:05:57 -0500
Date: Fri, 12 Feb 2010 21:05:40 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Wojciech Ploskonka <wploskonka@gmail.com>,
       Dimitrios Apostolou <jimis@gmx.net>, thomas@archlinux.org,
       Andrew Morton <akpm@linux-foundation.org>, Alex Chiang <achiang@hp.com>,
       Len Brown <lenb@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: High cpu temperature with 2.6.32, bisection shows commit
	69d258 (fwd)
Message-ID: <20100212210540.GA25752@srcf.ucam.org>
References: <alpine.LNX.2.00.1001100226570.1325@localhost.localdomain> <20100109164240.43b21247@infradead.org> <alpine.LNX.2.00.1001100251210.1334@localhost.localdomain> <20100112160734.89ee6b11.akpm@linux-foundation.org> <20100112213205.7d74808a@infradead.org> <alpine.LNX.2.00.1002102245200.1675@localhost.localdomain> <20100210205637.63131c24@infradead.org> <alpine.LNX.2.00.1002111929300.1668@localhost.localdomain> <4B747D7D.2070002@gmail.com> <20100211212415.2eace0c2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100211212415.2eace0c2@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 09:24:15PM -0800, Arjan van de Ven wrote:
> On Thu, 11 Feb 2010 22:58:21 +0100
> Wojciech Ploskonka <wploskonka@gmail.com> wrote:
> 
> > 08:06.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394
> > Controller (rev 05) (prog-if 10 [OHCI])
> 
> 08:06.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller
> (rev 05) (prog-if 10 [OHCI])
> 
> is the one having PME+ set.
> 
> Len: how do we handle PME's again?

Right now, nothing enables the GPE they're connected to and so they're 
entirely irrelevant.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
