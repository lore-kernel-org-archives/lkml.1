Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbYJOVQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbYJOVQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 17:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbYJOVQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 17:16:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54299 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbYJOVQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 17:16:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] ACPI suspend: Blacklist HP xw4600 Workstation for old code ordering
Date: Wed, 15 Oct 2008 23:20:05 +0200
User-Agent: KMail/1.9.9
Cc: Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, John Brown <john.brown3@hp.com>
References: <200810142254.07024.rjw@sisk.pl> <200810151605.35883.rjw@sisk.pl> <20081015141526.GA5633@srcf.ucam.org>
In-Reply-To: <20081015141526.GA5633@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810152320.06167.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 15 of October 2008, Matthew Garrett wrote:
> On Wed, Oct 15, 2008 at 04:05:35PM +0200, Rafael J. Wysocki wrote:
> > On Wednesday, 15 of October 2008, Matthew Garrett wrote:
> > > I think trying to work out what would be more useful than just adding it to
> > > a blacklist. 
> > 
> > Well, machines that require the "old" ordering are simply broken, because
> > you just can't assume that specific devices are not in D3 before you
> > execute _PTS.
> > 
> > IOW, we aren't doing anything wrong and the BIOS is buggy.
> 
> So how does Windows cope with this?

I don't know. :-(

One possible explanation is that the device causing the trouble is not put
into D3 at all during suspend, but I'm speculating here.

Thanks,
Rafael
