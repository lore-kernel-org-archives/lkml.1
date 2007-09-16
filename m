Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbXIPUYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbXIPUYR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 16:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbXIPUYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 16:24:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:35155 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbXIPUYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 16:24:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=dzCclxtpBicCHbjt1GD5gXoRUutslO0O0KHbLdmPnwopfweSGy94bk4uIb3aDKUkqrVucevJz+nOezWIeuerk/Awk9/PW/nLEW9i2j2y/a9bNsg6Jtj7qbtXwq5uUpfQhBYw6G1VU+9FyTAJk48/peE9SsvR5sEk8yGxN8SqmDA=
Message-ID: <38b2ab8a0709161324p6841c1f9h6f9422b0e6c4b5cd@mail.gmail.com>
Date: Sun, 16 Sep 2007 22:24:04 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: x86_64: vsyscall vs vdso
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm a bit puzzled because vdso doesn't seem to be used on my fedora 7:
I just compiled a trivial program which just call gettimeofday() and
ld.so resolves this call with vsyscall's gettimeofday.

Now I'm wondering when vdso is used, could anybody give me a clue ?

Another question: is vdso going to replace vsyscall at all ? If so how
are statically programs going to be handled ?

Thanks,
-- 
Francis
