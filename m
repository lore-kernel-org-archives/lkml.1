Return-Path: <linux-kernel-owner+w=401wt.eu-S1753102AbZEQRzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbZEQRzb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 13:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbZEQRzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 13:55:17 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:25980 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbZEQRzP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 13:55:15 -0400
MIME-Version: 1.0
In-Reply-To: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
Date: Sun, 17 May 2009 18:55:15 +0100
X-Google-Sender-Auth: c7d97b1a93fdd7e2
Message-ID: <b2cdc9f30905171055yaede81bp5443e8aae8b0e74a@mail.gmail.com>
Subject: Re: 2.6.30-rc6: Reported regressions from 2.6.29
From: Alex Bennee <kernel-hacker@bennee.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/16 Rafael J. Wysocki <rjw@sisk.pl>:
> This message contains a list of some regressions from 2.6.29, for which there
> are no fixes in the mainline I know of.  If any of them have been fixed already,
> please let me know.
>
> If you know of any other unresolved regressions from 2.6.29, please let me know
> either and I'll add them to the list.  Also, please let me know if any of the
> entries below are invalid.
>
> Each entry from the list will be sent additionally in an automatic reply to
> this message with CCs to the people involved in reporting and handling the
> issue.

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13171
> Subject         : 2.6.30-rc2 + xorg-intel-2.7.0 + DRM_I915_KMS = corruption
> Submitter       : Alex Bennee <kernel-hacker@bennee.com>
> Date            : 2009-04-19 6:27 (28 days old)
> References      : http://marc.info/?l=linux-kernel&m=124022460014812&w=4

All the main details on this are on the freedesktop bugzilla[1]. I can
confirm it's still a problem and I've been tracking the intel-next
tree for testing.

Fundamentally the problem is that X can't allocate any memory when KMS
is enabled on my chipset. Without knowing how memory should be
allocated from the kernel by the X driver I haven't been able to look
into it deeper. I've had some feedback from the intel guys but nothing
recently.

As always I stand ready to run tests and/or provide additional
diagnostics if required.


[1] https://bugs.freedesktop.org/show_bug.cgi?id=21480

-- 
Alex, homepage: http://www.bennee.com/~alex/
CV: http://www.bennee.com/~alex/cv.php
