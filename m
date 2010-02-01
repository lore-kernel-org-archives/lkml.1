Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab0BASB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 13:01:29 -0500
Received: from gv-out-0910.google.com ([216.239.58.190]:41500 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab0BASB2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 13:01:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aMIBKAmSGBgg5lstBX1hMOELHbB41MwZ4vlZRQsk9pzAm769R+physkVkMG2hRZ66U
         n7kG4ocvab/75sFAy8R65ekYjT9Gd3yp+xAbv8O4M4APdDdiXrpwP8TfkeBF6GsNxDT8
         YJhSLncsr5mb2NDsWkgN17rD/iLZWz4/eyQDQ=
MIME-Version: 1.0
In-Reply-To: <d3IDKWHT5gE.A.DLD.q8hZLB@chimera>
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>
	 <d3IDKWHT5gE.A.DLD.q8hZLB@chimera>
Date: Mon, 1 Feb 2010 19:01:25 +0100
Message-ID: <9ea470501002011001s7734a20ft4dd5d181baf714c3@mail.gmail.com>
Subject: Re: [Bug #14949] drm_vm.c:drm_mmap: possible circular locking 
	dependency detected
From: Borislav Petkov <petkovbb@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 1, 2010 at 1:22 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14949
> Subject         : drm_vm.c:drm_mmap: possible circular locking dependency detected
> Submitter       : Borislav Petkov <petkovbb@googlemail.com>
> Date            : 2009-12-26 9:45 (37 days old)
> References      : http://marc.info/?l=linux-kernel&m=126182073616279&w=4
> Handled-By      : Eric W. Biederman <ebiederm@aristanetworks.com>
> Patch           : http://patchwork.kernel.org/patch/70461/

Yes, this is fixed.

-- 
Regards/Gruss,
Boris
