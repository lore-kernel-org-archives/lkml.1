Return-Path: <linux-kernel-owner+w=401wt.eu-S1760887AbYBEUaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887AbYBEUaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:30:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758016AbYBEU3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:29:50 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52841 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756342AbYBEU3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:29:49 -0500
Subject: Re: [PATCH] enclosure: add support for enclosure services
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: ltuikov@yahoo.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>,
       "Accardi, Kristen C" <kristen.c.accardi@intel.com>
In-Reply-To: <471033.35291.qm@web31813.mail.mud.yahoo.com>
References: <471033.35291.qm@web31813.mail.mud.yahoo.com>
Content-Type: text/plain
Date: Tue, 05 Feb 2008 14:29:45 -0600
Message-Id: <1202243385.3133.82.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-05 at 11:33 -0800, Luben Tuikov wrote:
> > Wrong ... we don't export non-SCSI devices as SCSI
> > (with the single and
> > rather annoying exception of ATA via SAT).
> 
> I didn't say you should do that.  I had already
> mentioned that vendors export such controls
> as either enclosure or processor type devices,
> and this is why I told you that that is what
> needs to be exported, which incidentally is
> a device node of that type.
> 
> Without a common usage model already in the kernel
> to abstract (e.g. sd for block device, since you brought
> that up) your abstraction seems redundant and arbitrary.

Exactly, so the first patch in this series (a while ago now) was a
common usage model abstraction of enclosures, and the second was an
implementation in terms of SES.   I will do one in terms of SGPIO as
well ... assuming I ever find a SGPIO enclosure ...

> Your kernel code already uses READ DIAGNOSTIC, etc,
> and I'd rather leave that to user-space.

You can do it in user space as well.  It's just a bit difficult to get
information out of a SES enclosure without using it, and getting some of
the information is a requirement of the abstraction.

James


