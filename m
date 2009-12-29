Return-Path: <linux-kernel-owner+w=401wt.eu-S1752322AbZL2XQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbZL2XQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 18:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbZL2XQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 18:16:19 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:49984 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbZL2XQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 18:16:18 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Maciej J. Woloszyk" <mat@esi.com.pl>
Subject: Re: [Bug #14730] sky2 won't work after suspend/resume cycle
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera> <200912292229.47644.rjw@sisk.pl>
	<874on9tov5.fsf@devron.myhome.or.jp> <200912292341.56040.rjw@sisk.pl>
Date: Wed, 30 Dec 2009 08:16:16 +0900
In-Reply-To: <200912292341.56040.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Tue, 29 Dec 2009 23:41:55 +0100")
Message-ID: <87fx6tz7zz.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

>> Well, anyway, another likely one is - restore() should be called after
>> pci_pm_default_resume()?
>
> No, because we want the PCI standard config spaces to be restored before
> the device interrupts are enabled to avoid intermittent resume failures related
> to interrupt mishandling.
>
> That's why it is important to understand the nature of the sky2 failure here.

Um..., it was 0xff, so, I thought the config space is not working.  On
that system, the device is not affected by acpi's _DSW or _PSW?

Well, ok. If someone is working for it, that's enough good to me.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
