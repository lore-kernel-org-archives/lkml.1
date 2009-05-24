Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbZEXQsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbZEXQsA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 12:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbZEXQrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 12:47:52 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2035 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbZEXQrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 12:47:51 -0400
Subject: Re: [PATCH 3/3] drivers/ide/ide-core: Unsplit constant strings for
 pr_<level> and dev_<level>
From: Joe Perches <joe@perches.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Borislav Petkov <petkovbb@gmail.com>, Tejun Heo <tj@kernel.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4A19399B.8060207@ru.mvista.com>
References: <cover.1243062772.git.joe@perches.com>
	 <57f9dd5c33bcdd863793a3ee95ab050e8456bab4.1243062772.git.joe@perches.com>
	 <4A19399B.8060207@ru.mvista.com>
Content-Type: text/plain
Date: Sun, 24 May 2009 09:46:36 -0700
Message-Id: <1243183596.3560.19.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-24 at 16:12 +0400, Sergei Shtylyov wrote:
> > -		dev_err(&drive->gendev, "%s: packet size (0x%02x) is not 12 "
> > -			"bytes\n", s, packet_size);
> > +		dev_err(&drive->gendev,
> > +			"%s: packet size (0x%02x) is not 12 bytes\n",
>    When the message is broken by the format specifier, turning it into 
> one liner can hardly help seraching...

grep "is not 12 bytes"

>    Oh noes, the indentation...

trade-offs...

> > +	"(IO,CoD != (0,1) while issuing a packet command, retrying\n");
>    Sigh...

You seem to sigh a lot.  ;)

> > +	"(IO,CoD != (0,1) while issuing a packet command, ignoring\n");
>    Sigh...
> > +	"Strange, packet command initiated yet DRQ isn't asserted\n");
>    Sigh...
> > +		"(IO,CoD) != (0,1) while issuing a packet command\n");
>    Sigh...
> > +		"unexpected interrupt, status=0x%02x, count=%ld\n",
>    Hardly won anything...
> > + "%s side 80-wire cable detection failed, limiting max speed to UDMA33\n",
>     Will you really use the full message to serch here?
> > +		 "probing with STATUS(0x%02x) instead of ALTSTATUS(0x%02x)\n",
>    Same comment about the line broken by the format specifiers. This 
> wins absolutely nothing.

grep "STATUS.*ALTSTATUS"

> > +		"no response (status = 0x%02x), resetting drive\n",
>    And again...

grep "response.*resetting"

> > +			"%s Multimode Write multcount is not set\n",
>    Sigh...
> > +			"%s Multimode Read failure multcount is not set\n",
>    Sigh...
> > +		"%s %s: device not capable of full native PCI mode\n",
>    Sigh...
> > +		"%s %s: rewrite of PROGIF failed, wanted 0x%04x, got 0x%04x\n",
> > +		"%s %s: I/O baseregs (BIOS) are reported as MEM for port %d!\n",
>    Sigh...
> > +		"%s %s: not 100%% native mode: will probe irqs later\n",
>    Sigh...

cheers, Joe

