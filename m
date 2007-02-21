Return-Path: <linux-kernel-owner+w=401wt.eu-S932317AbXBUCgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317AbXBUCgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 21:36:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932359AbXBUCgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 21:36:15 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:13334 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315AbXBUCgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 21:36:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=B0FCbVbJKs75LJ6Zegh89BgLRNVE3LWa4Hg/0uiKzmXkJNzpYTfX/aRoX6Ea6fY8/m6HL3supQcmPxUqoBrUCn6x31fFR0+nMGCE2SivAhRNo1m6hL0JnrTP34mfaDxpegf7PiM2vbtn/ONlgbXSv8kM4wieoE22vmxArRsP/sw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Suleiman Souhlal <ssouhlal@freebsd.org>
Subject: Re: [PATCH 1/3] Make the IDE DMA timeout modifiable
Date: Wed, 21 Feb 2007 03:42:20 +0100
User-Agent: KMail/1.9.5
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070221011922.GA1777@freefall.freebsd.org> <200702210244.53514.bzolnier@gmail.com> <3063A690-4E3D-4A6E-A7DC-3E624121FBB8@freebsd.org>
In-Reply-To: <3063A690-4E3D-4A6E-A7DC-3E624121FBB8@freebsd.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702210342.20775.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 21 February 2007 03:13, Suleiman Souhlal wrote:
> 
> On Feb 20, 2007, at 5:44 PM, Bartlomiej Zolnierkiewicz wrote:
> 
> >
> > On Wednesday 21 February 2007 02:19, Suleiman Souhlal wrote:
> >> It can be changed via /proc/ide/hd?/settings.
> >
> > Why do we need to change IDE DMA timeout dynamically?
> 
> I've used it to test error recovery (for example).

Seems quite useable for developers but I would prefer not to
expose it in production kernels for end users.

> > BTW /proc/ide/hd?/settings is obsoleted
> 
> What's the preferred way of changing such settings, these days?

sysfs

ide.c:ide_dev_attrs[] for generic attributes valid for all devices

Thanks,
Bart
