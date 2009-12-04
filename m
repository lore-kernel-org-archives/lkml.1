Return-Path: <linux-kernel-owner+w=401wt.eu-S1755671AbZLDCi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbZLDCi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 21:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbZLDCiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 21:38:55 -0500
Received: from gate.crashing.org ([63.228.1.57]:38593 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456AbZLDCiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 21:38:55 -0500
Subject: Re: [PATCH] powerpc/mm: setting mmaped page cache property through
 device tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>, linuxppc-dev@ozlabs.org, paulus@samba.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <E389CC83-307F-4A7D-B90B-CD928A1D1D1D@kernel.crashing.org>
References: <1259663450-28790-1-git-send-email-leoli@freescale.com>
	 <1259665127.2076.363.camel@pasglop>
	 <2a27d3730912010334q24bf0e06g84839aae131475ec@mail.gmail.com>
	 <E389CC83-307F-4A7D-B90B-CD928A1D1D1D@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 13:38:51 +1100
Message-ID: <1259894331.2076.1245.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-01 at 15:35 +0100, Segher Boessenkool wrote:
> So make the memory known to the kernel, just tell the kernel not to
> use it.  If it's normal system RAM, just put it in the "memory" node
> and do a memreserve on it (or do something in your platform code); if
> it's some other memory, do a device driver for it, map it there.

Right, if he's going to map it cachable he shouldn't bother with using
mem= or crap like that. And /dev/mem should just work.

Cheers,
Ben

