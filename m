Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbZJDUqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbZJDUqu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 16:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758022AbZJDUqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 16:46:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42828 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758020AbZJDUqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 16:46:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: 2.6.32-rc1: various BUGs on resume from hibernation
Date: Sun, 4 Oct 2009 22:47:43 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc2-rjw; KDE/4.3.1; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4AC8B4A8.3050601@tuffmail.co.uk> <4AC8D568.9090103@tuffmail.co.uk>
In-Reply-To: <4AC8D568.9090103@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910042247.43528.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 October 2009, Alan Jenkins wrote:
> Alan Jenkins wrote:
> > I'm seeing a variety of BUGs on my EeePC 701 after hibernation.  
> > Sometimes they cause a hang during resume; sometimes they happen just 
> > after resume.  It doesn't happen all the time either -  I've just 
> > hibernated three times in a row with no problems.  It's most perplexing.
> >
> > One resume hang showed a series of SCSI backtraces and errors.  
> > Unfortunately I wasn't able to capture it at the time.  They were most 
> > probably related to the root device, an SSD controlled by ata_piix.
> >
> > Today on latest -git I captured this "bad swap file entry" problem.  I 
> > use a swap file for hibernation (I don't have a swap partition).
> 
> > Previously, on a slightly older kernel (still after 32-rc1), I 
> > captured this BUG in fget_light():
> 
> And later suspend to ram failed, and then showed a hung task warning.

As I already asked in the Bugzilla, can you verify that this is reproducible
without KMS?

Best,
Rafael
