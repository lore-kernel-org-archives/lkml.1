Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbXLDR4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbXLDR4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 12:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbXLDRy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 12:54:57 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:53183 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347AbXLDRy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 12:54:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HQ5fI75TD6SVByjL/f5n/Lt6BoyVLL0/6Gr48Fcog2Gn5WdjJ4I0q8DpquEyv3pr+3UIY7WATCGOO0d/OzDGvIu3UEaZ7wbobayeBPnKNhymdrxKOYmBy3mBIhjCD/HzBWu/vXDHnvcEFVffN+rhYPiJ06IZloihekv06QPmDRI=
Message-ID: <6934efce0712040954v74cf0b4bk19b49988bc828233@mail.gmail.com>
Date: Tue, 4 Dec 2007 09:54:54 -0800
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: solid state drive access and context switching
Cc: "Chris Friesen" <cfriesen@nortel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071203230629.725f4c7a@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47548BF4.3010907@nortel.com>
	 <20071203230629.725f4c7a@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Has anyone played with this concept?
>
> For things like SATA based devices they aren't that fast yet.

What is fast enough?

As I understand the basic memory technology, the hard limit is in the
100's of microseconds range for latency.  SATA adds something to that.
 I'd be surprised to see latencies on SATA SSD's as measured at the OS
level to get below 1 millisecond.

What happens we start placing NAND technology in lower latency, higher
bandwidth buses?  I'm guessing we'll get down to that 100's of
microseconds level and an order of magnitude higher bandwidth than
SATA.  Is that fast enough to warrant this more synchronous IO?

Magnetic drives have latencies ~10 milliseconds, current SSD's are an
order of magnitude better (~1 millisecond), new interfaces and
refinements could theoretically get us down one more (~100
microsecond).  I'm guessing the current block driver subsystem would
negate a lot of that latency gain.  Am I wrong?

BTW - This trend toward faster, lower latency busses is marching
forward.  2 examples; the ioDrive from Fusion IO, Micron's RAM-module
like SSD concept.
