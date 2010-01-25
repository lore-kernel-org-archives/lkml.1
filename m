Return-Path: <linux-kernel-owner+w=401wt.eu-S1752207Ab0AYI2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab0AYI2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 03:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844Ab0AYI2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 03:28:33 -0500
Received: from mail-ew0-f226.google.com ([209.85.219.226]:49357 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab0AYI2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 03:28:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=M3hUoKLmOakAIlXPxJ1XT4r/ASIeWtsmT08Byu01BrENooQczNKpUuGkvnrzrkTqI/
         XRcHMBxu59iNw4urY64f0rMHFMUWDf7BsDCoaiS367FCseP/FwFlxF+jrJYfhSwAlpGe
         627VEsUWghPBPSMV4TDKTS8Z0W0f7qP+yvupM=
Date: Mon, 25 Jan 2010 09:28:24 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [Bug #14949] drm_vm.c:drm_mmap: possible circular locking
 dependency detected
Message-ID: <20100125082824.GA5391@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	DRI <dri-devel@lists.sourceforge.net>,
	"Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
 <hE3x9c-4KZM.A.NoG.4KMXLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <hE3x9c-4KZM.A.NoG.4KMXLB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 24, 2010 at 11:04:33PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).

Yep, this one is fixed by the patch below. Thanks.

> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14949
> Subject		: drm_vm.c:drm_mmap: possible circular locking dependency detected
> Submitter	: Borislav Petkov <petkovbb@googlemail.com>
> Date		: 2009-12-26 9:45 (30 days old)
> References	: http://marc.info/?l=linux-kernel&m=126182073616279&w=4
> Handled-By	: Eric W. Biederman <ebiederm@aristanetworks.com>
> Patch		: http://patchwork.kernel.org/patch/70461/

-- 
Regards/Gruss,
    Boris.
