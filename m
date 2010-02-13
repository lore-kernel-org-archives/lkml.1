Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab0BMCTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 21:19:16 -0500
Received: from mail-pz0-f187.google.com ([209.85.222.187]:40867 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab0BMCTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 21:19:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=nhtnQ4LpWsnl5ySrRSLeGXeFz0fhuawHQEfhPw4K0dV+rTRxhZ6fEiK0ZhjqqVkluW
         iihlJK5YO9Uv/H2ajyGMFBTm75qmnJ7OqHoAUMNRnWraKbu+hCMqH15ukgsM4Kp3O/3o
         UAlGkXjlkJQ0NAiuM+AO95z8uRbwb5cCS/o0I=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 12 Feb 2010 18:10:39 -0800
Message-ID: <43e72e891002121810g25d21eb5y254969458a9a58e7@mail.gmail.com>
Subject: compat-wireless updated for 2.6.33-rc8, 2.6.32.8 and next-20100212
To: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-bluetooth <linux-bluetooth@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bleeding edge compat-wireless updates were stuck due to a
bluetooth hunk failing on net/bluetooth/hidp/core.c, that should be
fixed now, at least it compiles for me down to 2.6.27. I also hadn't
updated a 2.6.33-rcx releases in a while, as well as 2.6.32.y release.
This should all now be in synch with upstream. I never got reports
about MQ support on older kernels so I just threw in the code, issues
can be dealt with once actually found.

ath3k went in on 2.6.33-rc8 so we enable it now. Atheros Ethernet
AR8152/AR8152 support was submitted upstream for atl1c but it hasn't
been merged yet so likely it won't get into 2.6.33, but once its
merged for 2.6.34 I will just throw in the patch as an extra onto the
compat-wireless-2.6.33 releases.

Worth noting also is if you have any specific patch which did *not* go
into a stable release due to size but yet considered relatively
important and if it is merged upstream please send a note to
linux-wireless about it and we can consider enabling it if it is not
insane. This applies to new drivers as well. I will likely an an
extra/ dir. The only requirement is you *must* have the patch merged
upstream on one of the trees, either wireless-testing,
bluetooth-testing, or net-next-2.6. Reasoning for enabling patches
like these is as I have seen, even as hard we try we somehow can't get
rid of a small delta between what we feel needs to be supported and
what is on stable. My main concern over accepting patches like these
is creating a fork but forks can be avoided if we have a requirement
of first requiring the patch on a development tree.

Please report any issues found:

http://wireless.kernel.org/en/users/Documentation/Reporting_bugs

Stable releases:
=========

2.6.32.8:

sha1sum 694b453db50cd22798b754d022aca1e5ba45c8f1
http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.32/compat-wireless-2.6.32.8.tar.bz2
http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.32/ChangeLog-2.6.32.8-wireless

2.6.33-rc8:

sha1sum 4811f419acb1d9d12e5262bffc4892da71134510
http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.33/compat-wireless-2.6.33-rc8.tar.bz2
http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.33/ChangeLog-2.6.33-rc8-wireless

Bleeding edge release based on linux-next:
==========================

http://wireless.kernel.org/en/users/Download
http://wireless.kernel.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2

  Luis
