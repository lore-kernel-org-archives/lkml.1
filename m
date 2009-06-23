Return-Path: <linux-kernel-owner+w=401wt.eu-S1760525AbZFWPmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760525AbZFWPmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759194AbZFWPl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:41:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37613 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753793AbZFWPl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:41:58 -0400
Date: Tue, 23 Jun 2009 16:43:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andy Whitcroft <apw@canonical.com>,
       Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
       Mathias Urlichs <matthias@urlichs.de>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Reduce AACRAID hardware queue size
Message-ID: <20090623164303.3f85a799@lxorguk.ukuu.org.uk>
In-Reply-To: <1245771089.4149.88.camel@mulgrave.site>
References: <1245756306-29023-1-git-send-email-apw@canonical.com>
	<1245756306-29023-2-git-send-email-apw@canonical.com>
	<1245771089.4149.88.camel@mulgrave.site>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Incidentally, SGBCOUNT isn't queue depth, its maximum number of sectors
> in an individual transfer.  What we'd need to show for this to be the
> fix is that every 32 bit aacraid card is affected, which, given the
> paucity of bug reports, I don't think so.

Its usually a specific firmware revision that weird problems with aacraid
hardware are linked to so it is worth trying different firmwares.

Alan
