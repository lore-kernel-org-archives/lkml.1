Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbZADAp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbZADAp5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 19:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756030AbZADApZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 19:45:25 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37076 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992AbZADApY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 19:45:24 -0500
Date: Sun, 4 Jan 2009 01:59:04 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, david@lang.hm,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       yhlu.kernel@gmail.com
Subject: Re: early exception error
Message-ID: <20090104005904.GQ496@one.firstfloor.org>
References: <20090102174845.GD5372@localhost> <20090102175226.GE5372@localhost> <alpine.DEB.1.10.0901021131210.21567@asgard.lang.hm> <20090102203058.GH5372@localhost> <alpine.DEB.1.10.0901030823190.23262@asgard.lang.hm> <20090103161052.GB11093@localhost> <alpine.DEB.1.10.0901031118450.23262@asgard.lang.hm> <20090103190316.GB7367@localhost> <20090103212426.GC7367@localhost> <496001A3.1040201@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496001A3.1040201@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hint: line 442 in 2.6.28 is
> if (!bdata->node_bootmem_map)
> ;)
> 
> It's:
> 0xffffffff8096452a <alloc_bootmem_core+69>:     cmpq   $0x0,0x10(%rbp)
> and hence cr2 is 10.
> 
> node_data[nid] is NULL... But both of them are set up. Maybe too high nid (and
> pnum in sparse_init)?

I think it's because SRAT parsing failed and the fallback forget
to clean some state. Or at least I thought that until numa=noacpi
failed too (if it fails the same way that theory is not correct)

-Andi
> 

-- 
ak@linux.intel.com
