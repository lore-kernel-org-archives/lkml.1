Return-Path: <linux-kernel-owner+w=401wt.eu-S932078AbXE2Um6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbXE2Um6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760426AbXE2Umv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:42:51 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:46902
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758931AbXE2Umu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:42:50 -0400
From: Rob Landley <rob@landley.net>
To: Michael-Luke Jones <mlj28@cam.ac.uk>
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
Date: Tue, 29 May 2007 16:41:41 -0400
User-Agent: KMail/1.9.1
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
References: <200705272229.21263.rjw@sisk.pl> <200705272231.54535.rjw@sisk.pl> <6BD5252F-96CD-49D9-86C7-18115294D913@cam.ac.uk>
In-Reply-To: <6BD5252F-96CD-49D9-86C7-18115294D913@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705291641.43476.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 May 2007 4:45 pm, Michael-Luke Jones wrote:
> (Slightly OT: A particularly nasty race is when an initramfs  
> userspace is present, but firmware loading cannot occur because init  
> has not run, so proc hasn't been mounted, so a hotplug event handler  
> cannot be registered, despite the fact that the firmware is sitting  
> on the ramdisk mounted correctly...)

I believe that the current functionality is that /sbin/hotplug is the default.  
I think that if there is one in initramfs, it'll get called as a usermode 
helper, even before init has run.  (If it needs /proc /sys or /dev, setting 
it up properly is its problem, but not an insurmountable one.)

I remember discussion of this a while back, and that it was indeed 
intentional.  I dunno if anybody's actually tried it.

Rob
