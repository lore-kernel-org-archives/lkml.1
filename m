Return-Path: <linux-kernel-owner+w=401wt.eu-S933648AbXCKOPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933648AbXCKOPc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 10:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933647AbXCKOPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 10:15:32 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:35318 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933646AbXCKOP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 10:15:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=QxHGaSiq4Wjc3DUXvQFo0+50Jh6mxaeBCkhfHP4xa+lGO6jsXjuvQxhQ/Jx6huJj5q/pZmtASSMzIbLIYEznaEkMia4cRCZvUB7Mh6HQJzXArr5lqh7KpBYi7C5B36wsOPlyyecslpWkvance/Siq459b9UzHFsmwYlRjky3Px8=
Message-ID: <2375c9f90703110715v4278f83flbc9fce6c542472a5@mail.gmail.com>
Date: Sun, 11 Mar 2007 22:15:27 +0800
From: "Cong WANG" <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Style Question
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, list!

I have a question about coding style in linux kernel. In
Documention/CodingStyle, it is said that "Linux style for comments is
the C89 "/* ... */" style. Don't use C99-style "// ..." comments."
_But_ I see a lot of '//' style comments in current kernel code.

Which is wrong? The documentions or the code, or neither? And why?

Another question is about NULL. AFAIK, in user space, using NULL is
better than directly using 0 in C. In kernel, I know it used its own
NULL, which may be defined as ((void*)0), but it's _still_ different
from raw zero. So can I say using NULL is better than 0 in kernel?

Any reply is welcome. Thanks and have a nice day!
