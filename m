Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbXGCOAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbXGCOAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbXGCN7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 09:59:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:62675 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbXGCN7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 09:59:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=de+P3F6Ci3dIWm25vzGDnwTieBsVWW9WIGoJMdrfFFlUxuYc0LdKoB3ZDIe1eBHf2AZoWtUZQcRI/1MasnFUeTBBSSmABYM0IrAlDUkXDnXfpxPzSpJIwJvGkqehu0VhDnciKWGZY0s0TwC9npk6bPr0shO8aChRVk8LceE1YIw=
Date: Tue, 3 Jul 2007 15:59:49 +0200
From: Florian Attenberger <valdyn@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21.5 june 30th to july 1st date hang?
Message-ID: <20070703135949.GB19565@master.home>
References: <F1D642E5A91BC94D9504EC83AE19E6B0128A5C@ecqcmtlmail3.quebec.int.ec.gc.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <F1D642E5A91BC94D9504EC83AE19E6B0128A5C@ecqcmtlmail3.quebec.int.ec.gc.ca>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 08:44:00AM -0400, Fortier,Vincent [Montreal] wrote:
> Hi all,
> 
> All my servers and workstations running a 2.6.21.5 kernel hanged exactly
> when the date shift from june 30th to july 1st.
> 
> On my monitoring system every single station running a 2.6.21.5 kernel
> stoped responding exactly after midnight on the date shift from June
> 30th to July 1st.  Although, stations still running 2.6.18 to 2.6.20.11
> worked flawlessly.
> 
> I first tought there had been an electricity outage but two of my
> servers (dell PE 2950 dual-quad core) on UPS in our server room also
> hanged:
> Jun 30 23:55:01 urpdev1 /USR/SBIN/CRON[31298]: (root) CMD ([ -x
> /usr/lib/sysstat/sa1 ] && { [ -r "$DEFAULT" ] && . "$DEFAULT" ; [
> "$ENABLED" = "true" ] && exec /usr/lib/sysstat/sa1; })
> Jul  3 11:54:03 urpdev1 syslogd 1.4.1#17: restart.
> 
> I could not get anything on any of the 20+ consoles...  All the systems
> hanged at around the exact same time... When the date shifted from June
> 30th to July 1st in UTC ...?
> 
> Any clue any one?
> 
> - vin
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
there was one 'special' event at that date:
syslog.2.gz:Jul  1 01:59:59 master kernel: Clock: inserting leap second
23:59:60 UTC

