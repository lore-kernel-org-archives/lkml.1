Return-Path: <linux-kernel-owner+w=401wt.eu-S1751536Ab0AKGLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab0AKGLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 01:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929Ab0AKGLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 01:11:21 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:65273 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab0AKGLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 01:11:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=LvLQjO9ZY4SRh9cm05mN14HyiDMsYgjAyTJ2Na3Z3D4LGY7Rtd3fuGteYy8bajciYC
         fqCTKjTIxMU6YIvWEvWlbNsmyv9PBWIQmrbfECV08p6HrkcFwqd5SvBF3YMFCr+kaUKX
         vW+jVkDsM6P9mmovdIqDToc2HPwT6cY51f2ao=
Date: Mon, 11 Jan 2010 07:11:14 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Subject: Re: [Bug #14949] drm_vm.c:drm_mmap: possible circular locking
 dependency detected
Message-ID: <20100111061114.GB19865@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	DRI <dri-devel@lists.sourceforge.net>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
 <omZ8aBZReyD.A.NSH.MNlSLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <omZ8aBZReyD.A.NSH.MNlSLB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 10, 2010 at 11:32:56PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14949
> Subject		: drm_vm.c:drm_mmap: possible circular locking dependency detected
> Submitter	: Borislav Petkov <petkovbb@googlemail.com>
> Date		: 2009-12-26 9:45 (16 days old)
> References	: http://marc.info/?l=linux-kernel&m=126182073616279&w=4

Fix for that is at LKML-Reference: <m1y6kh30pi.fsf_-_@fess.ebiederm.org>

AFAIR, GregK-H will pick that one up.

-- 
Regards/Gruss,
    Boris.
