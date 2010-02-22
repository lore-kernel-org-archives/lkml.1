Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab0BVBZs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 20:25:48 -0500
Received: from mail-qy0-f184.google.com ([209.85.221.184]:38739 "EHLO
	mail-qy0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab0BVBZr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 20:25:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pw7ijyrnYMlq0Qin0vGmhl2mWECR3glK4E5q+LRNckcvwNAydJaRxHgrYu27kfiZ/h
         5uHxWV/xFhRb0ghFP0o5MqY48d94uj65ww1cryMwt1lfNQaHbUVhhLhqvtDyBPfHYy3b
         nPHndAHnSGvqk9XW9N5HtKtNmzN63k5SBA4cI=
MIME-Version: 1.0
In-Reply-To: <ClJsQB_ZlxO.A.eNH.WeagLB@chimera>
References: <b_eAfX__uZL.A.lvE.HcagLB@chimera>
	 <ClJsQB_ZlxO.A.eNH.WeagLB@chimera>
Date: Mon, 22 Feb 2010 09:25:46 +0800
Message-ID: <2375c9f91002211725u699a4b49y8dcae9829a3d3659@mail.gmail.com>
Subject: Re: [Bug #15142] sysfs-related lockdep warning in __blkdev_get
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Matti Aarnio <matti.aarnio--kernel-bugzilla@zmailer.org>,
       NeilBrown <neilb@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 5:30 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15142
> Subject         : sysfs-related lockdep warning in __blkdev_get
> Submitter       : Matti Aarnio <matti.aarnio--kernel-bugzilla@zmailer.org>
> Date            : 2010-01-25 13:38 (28 days old)
>
>

This should be fixed by the patchset from Eric too. Here:

http://lkml.org/lkml/2010/2/11/329
