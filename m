Return-Path: <linux-kernel-owner+w=401wt.eu-S1758855AbZAXUzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855AbZAXUzb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 15:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755646AbZAXUzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 15:55:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46087 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513AbZAXUzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 15:55:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Philip Langdale <philipl@overt.org>
Subject: Re: [PATCH] ricoh_mmc: Use suspend_late/resume_early
Date: Sat, 24 Jan 2009 21:55:01 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       linux kernel <linux-kernel@vger.kernel.org>, sdhci-devel@list.drzeus.cx
References: <39393.98.210.152.237.1232305880.squirrel@overt.org> <20090124185723.7dc9a875@mjolnir.drzeus.cx> <497B7CA3.3080802@overt.org>
In-Reply-To: <497B7CA3.3080802@overt.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901242155.02113.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 January 2009, Philip Langdale wrote:
> Pierre Ossman wrote:
> > On Sun, 18 Jan 2009 14:11:20 -0500 (EST)
> > philipl@overt.org wrote:
> > 
> >> If ricoh_mmc suspends before sdhci_pci, it will pull the card
> >> out from under the controller, which could leave the system in
> >> a very confused state.
> >>
> >> Using suspend_late/resume_early ensures that sdhci_pci suspends first
> >> and resumes second.
> >>
> >> Signed-off-by: Philip Langdale <philipl@overt.org>
> >> ---
> > 
> > What's the plan here? Apply for .29?
> 
> That's what I'd recommend - we are seeing reports of problems that
> would be fixed by this.
> 
> eg: http://lkml.org/lkml/2009/1/21/241

Agreed.

Thanks,
Rafael
