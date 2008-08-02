Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbYHBDGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbYHBDGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 23:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYHBDGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 23:06:34 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:21096 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbYHBDGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 23:06:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=cj3wG7blLJRTKj/qoA7eZzAxUDe2k35DBlA7sbq/XCMuLJ2uun8IFEJF76BwBTUJlX
         ryFGxt+QixWryF8q1IwFcIQg4rPrWcpQi5FQdHVG+zmLw7cI52QvxWb4ujTxspWAu7G3
         4hPCN/mkGEitWYRisFrEs7255Qymj5l/CZFmY=
Message-ID: <3ae3aa420808012006l6832f65cmb2e5a300d60cb708@mail.gmail.com>
Date: Fri, 1 Aug 2008 22:06:33 -0500
From: "Linas Vepstas" <linasvepstas@gmail.com>
Reply-To: linasvepstas@gmail.com
To: "John Stoffel" <john@stoffel.org>
Subject: Re: amd64 sata_nv (massive) memory corruption
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <18579.30533.807970.739285@stoffel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3ae3aa420808011030weadc61fvf6f850f0a4cfcb3e@mail.gmail.com>
	 <18579.30533.807970.739285@stoffel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/1 John Stoffel <john@stoffel.org>:

> Linas> -- system is amd64 dual core, ASUS M2N-E mobo, 4GB RAM
> Linas>    Northbridge is nVidia Corporation MCP55 Memory Controller
> Linas>    (rev a3)
>
> Are you running the latest BIOS?  As I recall, my motherboard is an
> M2N-SLI Deluxe, which is slightly different from yours.

Its recent. I bought the thing only some number of months ago.
The basic mobo design is 2-3 years old, though, its not bleeding edge,
it was meant to be a conservative, stable, functional choice.
I'd hope that they'd have things like this debugged by now. Sigh.

> Linas> Also of note:
> Linas> -- problem was observed earlier, when system had 3GB RAM in it.
>
> What did you do to upgrade to 4gb of ram?  Just pull the second pair
> of 512mb DIMMs and put in fresh 1gb DIMMs?  I've got a pair of 2gb
> DIMMs in my box.  I suspect you are seeing memory problems of some
> sort.

No See other email. memtest86 passes fine, the system has been in
heavy use as a compute server on large datasets. No problems at all,
spotless record. I've beeb manipulating multi-gigabyte files just fine
on the IDE disk, without any corruption at all. I can move them
around on NFS, too. They only get corrupted in the SATA disk,
where its immediate and widespread, and takes less than a minute
to occur.

> Next, I'd upgraded the BIOS to the latest release, and then reset the
> BIOS to the factory default or safe settings to see if that helps.

I'll give tht a whirl. Bios settings are still at factory defaults, I had no
reason to mess with them.

--linas
