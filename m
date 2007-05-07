Return-Path: <linux-kernel-owner+w=401wt.eu-S966243AbXEGTNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966243AbXEGTNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 15:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966192AbXEGTNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 15:13:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:54715 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966169AbXEGTNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 15:13:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=FyJVutK/PBlD3JGvK0QvCLe4ze9tR4LXjhieqfqDaRW5hFBvFrUh/uKtzkNTM+b5mviYYNRuNcLecUcv/Yhh+9IOTZ3425Yv4mkmT9ThVy8VB9g9ylYFwrfzJhyRAhQWYv6zhAqfKLj6bbkMJi6zrnn4U9Baj+EsP6tsCEV48kg=
Message-ID: <a44ae5cd0705071213md3a403bk3b4b6686a7e333db@mail.gmail.com>
Date: Mon, 7 May 2007 12:13:30 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org
Subject: 2.6.21-mm1+hotfix -- Time gets confused during resume from suspend (18014554.415987)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ 1278.513048] agpgart-intel 0000:00:00.0: LATE suspend
[ 1278.513791]  hwsleep-0323 [03] enter_sleep_state     : Entering
sleep state [S3]
[18014554.415987] Intel machine check architecture supported.
[18014554.416010] Intel machine check reporting enabled on CPU#0.
[18014554.416050] Back to C!
[ 1281.221504] agpgart-intel 0000:00:00.0: EARLY resume
[ 1281.221508] PCI: Calling quirk c01cbfe6 for 0000:00:00.0
[ 1281.221510] pci 0000:00:00.1: EARLY resume
[ 1281.221513] PCI: Calling quirk c01cbfe6 for 0000:00:00.1
