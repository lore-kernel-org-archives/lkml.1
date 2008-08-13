Return-Path: <linux-kernel-owner+w=401wt.eu-S1757585AbYHMSYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585AbYHMSYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbYHMSYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:24:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:56249 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbYHMSYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:24:15 -0400
Date: Wed, 13 Aug 2008 11:24:20 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, andi@firstfloor.org, riel@redhat.com,
       greg@kroah.com, tytso@mit.edu, viro@ZenIV.linux.org.uk,
       alan@lxorguk.ukuu.org.uk, peterz@infradead.org, hch@infradead.org
Subject: Re: TALPA - a threat model?  well sorta.
Message-ID: <20080813112420.12378ebf@infradead.org>
In-Reply-To: <20080813181714.GL1366@one.firstfloor.org>
References: <1218645375.3540.71.camel@localhost.localdomain>
	<20080813181714.GL1366@one.firstfloor.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 20:17:14 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> 
> I would suggest again to clarify this important point first. It has
> significant impact on the whole design.

agreed.

> 
> Personally I would think not protecting against root would be quite
> limiting (e.g. it would mean that e.g. if some worm trojans rpms
> people download then they wouldn't be caught because rpms are
> installed as root),

on argument could be that root apps like that could/should do explicit
scanning regardless.
(if we have an explicit interface to scan a file that's not too hard)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
