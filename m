Return-Path: <linux-kernel-owner+w=401wt.eu-S937768AbZLHROj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937768AbZLHROj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 12:14:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937435AbZLHROh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 12:14:37 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:60260 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936085AbZLHROf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 12:14:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=A8Y6N1agJYHRe1mRiuBwro9zQWEPYhqyWZ25kt6ObHVs2Lam56Jgw+hF6TXwjku8LG
         JINflo1vP04X07H4u7fWcadiS7I6/5/iMZHp7Rixgq3yvymdptx0IHZ21MLKjQfd+B09
         rpLlX4heFnieEhwciIbks9qGwUw2JpI1sxnQE=
MIME-Version: 1.0
Date: Tue, 8 Dec 2009 19:14:39 +0200
Message-ID: <8b8dd87a0912080914h3d71ea6x3052582b662d5f73@mail.gmail.com>
Subject: Badness at arch/powerpc/mm/pgtable.c:286
From: kordex - <kordex@gmail.com>
To: linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I turned some debuging options in order to trace rcutree problems but
after turning debugging on it began just to loop on this:

http://xnet.fi/opt/pics/pgtable_badness.jpg
1.5M   pgtable_badness.jpg

I am sorry that I could not produce full dmesg.

Kernel config: http://xnet.fi/opt/apps/lkml-2.6.32-vanilla.debug.config.txt

--Mikko Kortelainen
