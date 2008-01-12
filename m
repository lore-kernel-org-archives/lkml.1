Return-Path: <linux-kernel-owner+w=401wt.eu-S1763516AbYALLR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763516AbYALLR5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 06:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762503AbYALLRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 06:17:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33041 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762361AbYALLRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 06:17:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] PM: Do not destroy/create devices while suspended (rev. 2)
Date: Sat, 12 Jan 2008 12:20:21 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-pm@lists.linux-foundation.org, linux-acpi@vger.kernel.org,
       stern@rowland.harvard.edu, lenb@kernel.org,
       linux-kernel@vger.kernel.org, pavel@suse.cz, mingo@elte.hu,
       gregkh@suse.de, tglx@linutronix.de, ak@suse.de
References: <200801020032.45529.rjw@sisk.pl> <20080111164613.7791bb94.akpm@linux-foundation.org> <20080111164904.3ca81602.akpm@linux-foundation.org>
In-Reply-To: <20080111164904.3ca81602.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801121220.23223.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 12 of January 2008, Andrew Morton wrote:
> On Fri, 11 Jan 2008 16:46:13 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > The first patch in the series introduces such a mechanism.  The remaining three
> > > patches modify the MSR, x86-64 MCE and cpuid drivers in accordance with the
> > > above approach.
> > 
> > These patches are a preresuisite to
> > gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch and its
> > later fixed-up versions.
> > 
> > So what I have now is
> > 
> > revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
> > pm-introduce-destroy_suspended_device.patch
> > pm-do-not-destroy-create-devices-while-suspended-in-msrc-rev-2.patch
> > pm-do-not-destroy-create-devices-while-suspended-in-mce_64c.patch
> > pm-do-not-destroy-create-devices-while-suspended-in-cpuidc.patch
> > pm-acquire-device-locks-on-suspend-rev-3.patch
> > pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes.patch
> > pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes-2.patch
> > 
> > So what needs to happen in Greg's tree is
> > 
> > a) drop the old gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
> > 
> > b) apply these four patches
> > 
> > c) apply the new pm-acquire-device-locks-on-suspend-rev-3.patch (and its fixups)
> 
> err, no.  pm-introduce-destroy_suspended_device.patch demolishes
> pm-acquire-device-locks-on-suspend-rev-3.patch
> 
> Confused, giving up.

Sorry, I didn't know you still had pm-introduce-destroy_suspended_device.patch.

Please drop:

pm-do-not-destroy-create-devices-while-suspended-in-msrc-rev-2.patch
pm-do-not-destroy-create-devices-while-suspended-in-mce_64c.patch
pm-do-not-destroy-create-devices-while-suspended-in-cpuidc.patch
pm-acquire-device-locks-on-suspend-rev-3.patch
pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes.patch
pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes-2.patch

and I'll resend a new checkpatch.pl-compliant version of the
pm-acquire-device-locks-on-suspend patch with appropriate sign-offs to you
and Greg.
