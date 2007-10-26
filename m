Return-Path: <linux-kernel-owner+w=401wt.eu-S1764018AbXJZQcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764018AbXJZQcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758114AbXJZQcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:32:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51174 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763559AbXJZQcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:32:11 -0400
Date: Fri, 26 Oct 2007 09:30:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
cc: Russell King <rmk@arm.linux.org.uk>, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression: commit "ide: constify struct ide_port_info" causes
 breakage
In-Reply-To: <47221164.10200@ru.mvista.com>
Message-ID: <alpine.LFD.0.999.0710260929290.30120@woody.linux-foundation.org>
References: <20071026155648.GB4321@flint.arm.linux.org.uk>
 <47221164.10200@ru.mvista.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Oct 2007, Sergei Shtylyov wrote:
> 
>    We can just convert cariables declared as 'struct hpt_info' to const too -- 
> they are read-only templates.

Generally "__devinitdata" is better than "const", since it means that the 
data may be thrown away.

So if you drop one over the other, it's generally the "const" that should 
be dropped ;/

		Linus
