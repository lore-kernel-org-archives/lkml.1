Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbYGCVRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbYGCVRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbYGCVRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:17:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44063 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953AbYGCVRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:17:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Handling of suspend/hibernation patches
Date: Thu, 3 Jul 2008 23:18:40 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       stern@rowland.harvard.edu, andi@firstfloor.org, greg@kroah.com,
       jbarnes@virtuousgeek.org, lenb@kernel.org,
       torvalds@linux-foundation.org, linux-pm@lists.linux-foundation.org,
       sfr@canb.auug.org.au, pavel@suse.cz, mingo@elte.hu
References: <200807032247.34049.rjw@sisk.pl> <20080703140154.18876f5a.akpm@linux-foundation.org>
In-Reply-To: <20080703140154.18876f5a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807032318.41446.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 3 of July 2008, Andrew Morton wrote:
> On Thu, 3 Jul 2008 22:47:32 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > Hi,
> > 
> > Recently, we've had some problems with the handling of suspend/hibernation
> > patches, because they tend to touch multiple subsystems at a time.  As a
> > result, it usually is not clear which tree they should be included in and at
> > the moment there are suspend/hibernation patches in the PCI, ACPI, x86
> > trees, as well as in -mm.  Of course the resulting dependencies between those
> > trees are a pain to Stephen and their maintainers.
> > 
> > After the last Kernel Summit we tried to create a branch in the ACPI tree for
> > suspend/hibernation patches (thanks Len!) and that had worked quite well until
> > we started to work on the core device power management.  This coincided with
> > the creation of linux-next and collecting suspend/hibernation patches in the
> > ACPI tree became inconvenient.
> > 
> > Now, we could go back to the old way of handling suspend/hibernation patches,
> > which was to merge them through -mm, but the disadvantage of this would be that
> > the patches wouldn't go through linux-next.  However, I'd like
> > suspend/hibernation patches to be included in linux-next, so that they can get
> > as much testing as possible.
> 
> I need to get butt into gear and get most-of-mm into linux-next.  I'll
> be picking that up when 2.6.27-rc1 is done.
> 
> So we can just keep this tree in -mm (and hence linux-next) if you like.

Well, that will save me quite a bit patch management work. :-)

Let's keep that in -mm, then.

Thanks,
Rafael
