Return-Path: <linux-kernel-owner+w=401wt.eu-S1753192AbYIJNqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbYIJNqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 09:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYIJNqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 09:46:14 -0400
Received: from mx1.moondrake.net ([212.85.150.166]:56350 "EHLO
	mx1.mandriva.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751049AbYIJNqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 09:46:13 -0400
X-Greylist: delayed 1873 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Sep 2008 09:46:12 EDT
X-Spam-Virus: No
To: Karel Zak <kzak@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng v2.14.1 (stable)
X-URL: <http://www.mandrivalinux.com/
References: <20080910124008.GF2943@nb.net.home>
From: Thierry Vignaud <tvignaud@mandriva.com>
Organization: Mandriva
Date: Wed, 10 Sep 2008 15:14:49 +0200
In-Reply-To: <20080910124008.GF2943@nb.net.home> (Karel Zak's message of "Wed\, 10 Sep 2008 14\:40\:08 +0200")
Message-ID: <m24p4op2gm.fsf@vador.mandriva.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karel Zak <kzak@redhat.com> writes:

> The stable util-linux-ng 2.14.1 release is available at
> 
>     ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.14/
> 
> Feedback and bug reports, as always, are welcomed.

Err, since you're both:
- the official upstream author,
- the official packager in fedora,

why do you package so many uncommited patches in your fedora package?

$ ch /fedora/development/SRPMS/util-linux-ng-2.14.1-0.1.fc10.src.rpm   
* Fri Aug 15 2008 Karel Zak <kzak@redhat.com> 2.14.1-0.1
- upgrade to 2.14.1-rc1
- refresh old patches

$ rpm -qpl /fedora/development/SRPMS/util-linux-ng-2.14.1-0.1.fc10.src.rpm   
floppy-0.16.tar.bz2
nologin.8
nologin.c
util-linux-ng-2.13-ctrlaltdel-man.patch
util-linux-ng-2.13-fdformat-man-ide.patch
util-linux-ng-2.13-fdisk-b-4096.patch
util-linux-ng-2.13-floppy-generic.patch
util-linux-ng-2.13-floppy-locale.patch
util-linux-ng-2.13-ipcs-32bit.patch
util-linux-ng-2.13-login-lastlog.patch
util-linux-ng-2.13-login-pamstart.patch
util-linux-ng-2.13-mount-pamconsole.patch
util-linux-ng-2.14-blockdev-rmpart.patch
util-linux-ng-2.14-mount-file_t.patch
util-linux-ng-2.14-mount-managed.patch
util-linux-ng-2.14.1-rc1.tar.bz2
util-linux-ng-60-raw.rules
util-linux-ng-chsh-chfn.pamd
util-linux-ng-login.pamd
util-linux-ng-remote.pamd
util-linux-ng.spec
