Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbZBJVxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbZBJVxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 16:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755477AbZBJVxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 16:53:30 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:55396 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457AbZBJVx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 16:53:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=NRon//3p5lYVSSAj/lHeY7tncIqg/X4ckYavHeM/gQjfnhndII+2hIqKc3HaavN2bS
         qe2eAXxNiQAqEZH2XWZwP0dSS358acZzCKPGdFHy7Q2/ms2sBLZU1kFxnQEnriIB2tCJ
         ZJ+c8yK9rvbrUTnUjMI7gt58e/ShiUc44qYnE=
MIME-Version: 1.0
Date: Tue, 10 Feb 2009 21:53:27 +0000
Message-ID: <c6b1100b0902101353q2c5ad750t2a901de97dc5fe5@mail.gmail.com>
Subject: 2.6.29-rc4-git2 build failure
From: Chris Clayton <chris2553@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-rc4-git2 build fails after "git pull" a few minutes ago

 CC      ipc/shm.o
ipc/shm.c:371:49: error: macro "hugetlb_file_setup" passed 3
arguments, but takes just 2
ipc/shm.c: In function 'newseg':
ipc/shm.c:371: error: 'hugetlb_file_setup' undeclared (first use in
this function)
ipc/shm.c:371: error: (Each undeclared identifier is reported only once
ipc/shm.c:371: error: for each function it appears in.)
make[1]: *** [ipc/shm.o] Error 1
make: *** [ipc] Error 2

Happy to test patches

Chris

-- 
In a world without walls and fences, who needs windows and gates?
