Return-Path: <linux-kernel-owner+w=401wt.eu-S1757336AbYBXTmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336AbYBXTmx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 14:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbYBXTmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 14:42:44 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:53061 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbYBXTmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 14:42:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dQwFaowEN7O7MQ6jbYn8td8KksBmCy/gpqYvdBtpJBExdZW6BYpmvBOtfzDXyIBtKxKhW0RRgBBPVrVMTOIKtDYIo07ZE2LnSPhdG37Hno3uARkU56rmLHwX/BihxVrYp0g4CRbWDuLPl163lQKjjIYMUFfxMudwoolHjvK8PfQ=
Message-ID: <c4e36d110802241142t9cb340dpc42a2d89166beb7b@mail.gmail.com>
Date: Sun, 24 Feb 2008 20:42:42 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Pierre Ossman" <drzeus-mmc@drzeus.cx>,
       "Kernel development list" <linux-kernel@vger.kernel.org>,
       "pm list" <linux-pm@lists.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.0802241409320.11316-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802241451.17334.rjw@sisk.pl>
	 <Pine.LNX.4.44L0.0802241409320.11316-100000@netrider.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/2/24, Alan Stern <stern@rowland.harvard.edu>:
> On Sun, 24 Feb 2008, Rafael J. Wysocki wrote:
>
>
> > > You know, with this new patch we probably don't need
>  > > device_pm_schedule_removal() any more.
>  >
>  > No, we don't.  However, because of that dpm_suspend() and device_power_down()
>  > need to be changed not to assume that the removed devices will end up on
>  > dpm_destroy.
>
>
>  with analogous changes to dpm_suspend().
>
>  Any more suggestions for updates?
>

Is there any current patch I should actually test - it looks there is
ongoing discussion from the time Rafael has proposed his last patch to
check by me: http://bugzilla.kernel.org/attachment.cgi?id=14961&action=view

But I think it's visible the only suspend update will not resolve my
problems and the problems is deeper in the mmc.

So should I still test yesterdays' patch ?

Zdenek

Zdenek
