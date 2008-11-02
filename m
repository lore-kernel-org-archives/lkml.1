Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbYKBVJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbYKBVJi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 16:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbYKBVJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 16:09:27 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:39746 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbYKBVJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 16:09:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hz/Hq6Fmc/39eeifhKlQtEg+udj4C2mttmcMXuks1Qi9Fs8UiB+fFhjzVFvgju9Q3O
         NjO7uCECVA4tYHv2aiwdbd+mmZb9aXpv+2w6gtVkws5ib91wVFMgUxTZuH+E0TcN0i/u
         aJsgHe7wcfN2pX0/mLQYje1UovEET1sVBXuwA=
Message-ID: <19f34abd0811021309u341b0512x2220720176011e78@mail.gmail.com>
Date: Sun, 2 Nov 2008 22:09:24 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11854] v2.6.28-rc1: readlink /proc/*/exe returns uninitialized data to userspace
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>
In-Reply-To: <wOAXuecskPD.A.dhG.lkeDJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <603i_OdVYPF.A.7_D.mjeDJB@chimera>
	 <wOAXuecskPD.A.dhG.lkeDJB@chimera>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 2, 2008 at 5:07 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=11854
> Subject         : v2.6.28-rc1: readlink /proc/*/exe returns uninitialized data to userspace
> Submitter       : Vegard Nossum <vegard.nossum@gmail.com>
> Date            : 2008-10-25 17:14 (9 days old)
> References      : http://marc.info/?l=linux-kernel&m=122495490201663&w=4

Been trying to reproduce this one since I saw it, and I think it can
be written off as can't reproduce :-(

Maybe I can contribute a patch that verifies that the return value ==
strlen(buffer), WARN_ON otherwise? And hope that somebody runs into
it.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
