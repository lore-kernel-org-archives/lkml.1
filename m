Return-Path: <linux-kernel-owner+w=401wt.eu-S1423215AbXDYFtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423215AbXDYFtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 01:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbXDYFtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 01:49:51 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:22442 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbXDYFtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 01:49:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=InKNzuo2yCh4YWhYvWZ78KcDw0OckT3DfAPU781pF4SobZd5tv4x2hTfIySvRlxzzqmH7lxxwCagcmnT859mMCK0y4Gcb6W2W9ovg6dKaegj4MMi5GdA26XwbrRKgwgbOLBbZqiJy7Nn2GCzJShLXqR2r2LzzPhXzLVKjYIxDf8=
Message-ID: <a44ae5cd0704242249i210ba860i659c230b5dbb211c@mail.gmail.com>
Date: Tue, 24 Apr 2007 22:49:48 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.21-rc7-mm1 + sysfs-oops-workaround.patch -- software suspend failed (1 tasks refusing to freeze)
Cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Oleg Nesterov" <oleg@tv-sign.ru>
In-Reply-To: <20070424224137.0ccf7874.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0704242227x14986fe3v5c2fc3a5bceedc89@mail.gmail.com>
	 <20070424224137.0ccf7874.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 24 Apr 2007 22:27:44 -0700 "Miles Lane" <miles.lane@gmail.com> wrote:
>
> > [ 1251.506964] PM: Preparing system for mem sleep
> > [ 1251.514790] Stopping tasks ...
> > [ 1271.456065] Stopping user space processes timed out after 20
> > seconds (1 tasks refusing to freeze):
> > [ 1271.456243]  multiload-apple
> > [ 1271.456291] Restarting tasks ... done.
> >
> > This isn't happening under earlier builds I've tested.  How can I debug this?
> >
>
> hm, that's multiload-applet, some gnome thing.
>
> sysrq-T, perhaps?  Perhaps the process is sleeping in the kernel somewhere.

Should I wait for the next patch from Tejun before retesting?  Perhaps
this suspend problem is a side effect of the locking problem he
mentioned.

         Miles
