Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbYIJO0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbYIJO0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 10:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYIJO0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 10:26:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbYIJO0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 10:26:09 -0400
Date: Wed, 10 Sep 2008 16:26:05 +0200
From: Karel Zak <kzak@redhat.com>
To: Thierry Vignaud <tvignaud@mandriva.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng v2.14.1 (stable)
Message-ID: <20080910142605.GA6092@nb.net.home>
References: <20080910124008.GF2943@nb.net.home> <m24p4op2gm.fsf@vador.mandriva.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m24p4op2gm.fsf@vador.mandriva.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 03:14:49PM +0200, Thierry Vignaud wrote:
> Err, since you're both:
> - the official upstream author,
> - the official packager in fedora,
> 
> why do you package so many uncommited patches in your fedora package?

> util-linux-ng-2.13-ctrlaltdel-man.patch

 distribution specific patch

> util-linux-ng-2.13-fdformat-man-ide.patch
> util-linux-ng-2.13-floppy-generic.patch
> util-linux-ng-2.13-floppy-locale.patch

 distribution specific patches -- upstream does not include
 the"floppy" util

> util-linux-ng-2.13-fdisk-b-4096.patch
> util-linux-ng-2.13-ipcs-32bit.patch
> util-linux-ng-2.13-login-lastlog.patch
> util-linux-ng-2.13-login-pamstart.patch

 not sure, maybe good enough for upstream (we will see in 2.15..)

> util-linux-ng-2.13-mount-pamconsole.patch

 old distribution specific patch (not planned for F10)

> util-linux-ng-2.14-blockdev-rmpart.patch

 (stupid) distribution specific patch (duplicate delpart(1)
 functionality.

> util-linux-ng-2.14-mount-file_t.patch

 already in upstream devel repository

> util-linux-ng-2.14-mount-managed.patch

 distribution specific patch


    Karel

-- 
 Karel Zak  <kzak@redhat.com>
