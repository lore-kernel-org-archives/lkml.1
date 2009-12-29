Return-Path: <linux-kernel-owner+w=401wt.eu-S1752279AbZL2XkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbZL2XkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 18:40:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZL2XkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 18:40:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41018 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbZL2XkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 18:40:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14730] sky2 won't work after suspend/resume cycle
Date: Wed, 30 Dec 2009 00:40:15 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Maciej J. Woloszyk" <mat@esi.com.pl>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera> <200912292341.56040.rjw@sisk.pl> <87fx6tz7zz.fsf@devron.myhome.or.jp>
In-Reply-To: <87fx6tz7zz.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912300040.15773.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 December 2009, OGAWA Hirofumi wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> >> Well, anyway, another likely one is - restore() should be called after
> >> pci_pm_default_resume()?
> >
> > No, because we want the PCI standard config spaces to be restored before
> > the device interrupts are enabled to avoid intermittent resume failures related
> > to interrupt mishandling.
> >
> > That's why it is important to understand the nature of the sky2 failure here.
> 
> Um..., it was 0xff, so, I thought the config space is not working.  On
> that system, the device is not affected by acpi's _DSW or _PSW?

I don't think it is, but of course I'm not sure.

Rafael
