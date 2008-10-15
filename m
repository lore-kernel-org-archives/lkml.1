Return-Path: <linux-kernel-owner+w=401wt.eu-S1758793AbYJOOPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbYJOOPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758721AbYJOOPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:15:33 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:48330 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757455AbYJOOPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:15:32 -0400
Date: Wed, 15 Oct 2008 15:15:26 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, John Brown <john.brown3@hp.com>
Subject: Re: [PATCH] ACPI suspend: Blacklist HP xw4600 Workstation for old code ordering
Message-ID: <20081015141526.GA5633@srcf.ucam.org>
References: <200810142254.07024.rjw@sisk.pl> <20081015085809.GA1061@srcf.ucam.org> <200810151605.35883.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810151605.35883.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 04:05:35PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, 15 of October 2008, Matthew Garrett wrote:
> > I think trying to work out what would be more useful than just adding it to
> > a blacklist. 
> 
> Well, machines that require the "old" ordering are simply broken, because
> you just can't assume that specific devices are not in D3 before you
> execute _PTS.
> 
> IOW, we aren't doing anything wrong and the BIOS is buggy.

So how does Windows cope with this?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
