Return-Path: <linux-kernel-owner+w=401wt.eu-S1763555AbYESU3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763555AbYESU3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 16:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbYESU2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 16:28:52 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:53075 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbYESU2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 16:28:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QCBLskp1AO+Rb+WehEPtEpYMPk9qJZaTWTlje2ywzr/wWEseGx+kjdshuyqMaN1Q/wjOli9963SpIumURlFFbcULhd4/CmNfSS86u6VjvMH61nW2jhiK67EU/L4W60B55C/rzmY/Tk+k0lxPA3bi9BV2lfa+5DT+yO6itpDxGIQ=
Message-ID: <df47b87a0805191328u664363c8la79831595a0fd1df@mail.gmail.com>
Date: Mon, 19 May 2008 23:28:50 +0300
From: "Ioan Ionita" <opslynx@gmail.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: BISECTED REGRESSION: 2.6.26-rc2: FUSE changes break mount of ntfs-3g
Cc: linux-kernel@vger.kernel.org, mszeredi@suse.cz, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org
In-Reply-To: <E1JyB6E-0000Ya-6v@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <df47b87a0805171337h5da01cc4pd9df7d318afc47c2@mail.gmail.com>
	 <E1Jxza1-0007YO-KM@pomaz-ex.szeredi.hu>
	 <df47b87a0805191117m278580d2n2e23c48452ee4a19@mail.gmail.com>
	 <E1JyB6E-0000Ya-6v@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 10:32 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:

> Thanks!
>
> The problem seems to be that if a device isn't partitioned (and the
> raid-0 device isn't), then fuse will register its own BDI with the
> same name as the one belonging to the underlying device.
>
> Here's a patch that should fix it.  Can you please confirm?

Confirmed. Patch fixed the issue for me! RAID NTFS mounts just fine
and behaves as expected.

> Thanks,
> Miklos

No, thank you!

Cheers,

Ioan
