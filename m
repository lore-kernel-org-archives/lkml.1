Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbYL2FkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbYL2FkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 00:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbYL2Fj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 00:39:57 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:62859 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbYL2Fj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 00:39:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:sender:to:subject:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :x-google-sender-auth;
        b=War8e5j/Eh9tq+9+wXF+Vy3r0u54ACZpEQYit5lsaA+8f3oV6OZjlEt3zMWQfDyGuF
         2sSxWQBg3cqw5/0IOw90NQeQl3eWq9SY+txo0sPMi5bukv7anRHWYIU045DYvnvKjwgy
         NU6V9bOel49if38cKI7qbZecHPIn95FJxwhI4=
Message-ID: <43d009740812282139x7597aafbn4474455c1aa1e0e8@mail.gmail.com>
Date: Mon, 29 Dec 2008 12:39:55 +0700
From: "Igor Podlesny" <for.poige+linux@gmail.com>
Reply-To: for.poige+linux@gmail.com
To: linux-kernel@vger.kernel.org
Subject: Hi! I've noticed that kernel.org advertises 2.6.28 as "The latest stable version of the Linux kernel is".
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: c028996e97432298
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually that's either a mistake or I don't know what you guys call "a
stable version".

Since 2.6.24 there're serious regressions in all the following
"stable" releases. Both my own experience + http://www.kerneloops.org/
proves that.

Just to bring in some examples:

-- using 2.6.25.x I started to notice "oops"es in dmesg (what hadn't
been happening for a long time).

-- since 2.6.26 mine desktop system can't go suspend or hibernate. It
tries, but immediately returns from that trying.

-- Copying several rather big files (~ 25--45 GiB) from XFS on LVM-2
on MDraid partition to another one, I had the system rebooted both
with 2.6.28 and 2.6.27.10 (accomplished using 2.6.24.7-rt(sic!)25). As
you probably understand, that's the case you even can't trace where's
the problem, at least on a desktop with GUI, not on server with plain
text display. Although, I'm afraid even text display wouldn't had a
chance to show anything, tracing that problem.

So, I don't feel Linux is stable since 2.6.24. Do you?

(I'm not subscribed to the list, please cc:)

-- 
End of message. Next message?
