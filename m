Return-Path: <linux-kernel-owner+w=401wt.eu-S934177AbZLFTEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934177AbZLFTEk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 14:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933978AbZLFTEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 14:04:38 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:63560 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934161AbZLFTEd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 14:04:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type
         :content-transfer-encoding:date:message-id:mime-version:x-mailer;
        b=Dv2kndVzI/bp/EQIoebzb8bpWs9xnle/5mTHUKN6y3K5PR/jQEv+cLW3ALOa/Gu6XD
         mjJEKwQqFlCn4VJTjJoxvQ/u8Wbxk4ySRlHWML1DRXHy5tXOF4YmCIzDrm9w033ZL7RN
         4AO2MR3U8IA85zvoLib+RSncFCz0hV8Sd2xiQ=
Subject: Re: [linux-pm] [GIT PULL] PM updates for 2.6.33
From: Victor Lowther <victor.lowther@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0912060953190.4442-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0912060953190.4442-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 06 Dec 2009 13:04:36 -0600
Message-ID: <1260126276.13057.13.camel@studio>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-06 at 10:23 -0500, Alan Stern wrote:
> On Sat, 5 Dec 2009, Linus Torvalds wrote:
> That's ridiculous.  Having gone to all the trouble of building a device
> tree, one which is presumably still almost entirely correct, why go to
> all the trouble of tearing it down only to rebuild it again?  (Note:
> I'm talking about resume-from-RAM here, not resume-from-hibernation.)

There should be nothing special or privileged at all about the device
tree that gets built at boot time.

Consider the scenario of the laptop user with a docking station.
Adding, removing, and rewriting vast swaths of the device tree across
suspend/resume and hibernate/thaw is very easy to do when you are
plugging a laptop into one or more docking stations.

> Instead what we do is verify that the devices we remember from before
> the suspend are still there, and then asynchronously handle new devices
> which have been plugged in during the meantime.  Doing this involves
> relatively little extra or new code; most of the routines are shared
> with the runtime PM and device reset paths.

Devices can vanish across suspend to RAM just as easily as they can be
added.

> 
> _______________________________________________
> linux-pm mailing list
> linux-pm@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/linux-pm

