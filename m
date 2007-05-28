Return-Path: <linux-kernel-owner+w=401wt.eu-S1756940AbXE1EMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbXE1EMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 00:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbXE1EMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 00:12:13 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:64462 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbXE1EML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 00:12:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Dn5PxWkEEaX4iuKyjwRKNveHq6r8rRkCglQCmbHPbA5SUPCn8zwLZMmlMnD9A81j9W7Q+cg6JTl3COBzt44tzvZ6o/L6yG/dNQ2nIQ8kO5SgbUVNIA+z97J5iUpr6e7hPFQ5frI6de63FxkATmcOuy9OhxygbNfxCfVTND+KQ5I=
Message-ID: <64026d4a0705272112r23b77c25sd1bb89758abd2632@mail.gmail.com>
Date: Mon, 28 May 2007 09:42:10 +0530
From: "pradeep singh" <p.singh.rautela@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Altering kernel path execution using module
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Is it possible to change the normal kernel execution path using a
loadable module, without actually patching the kernel?
e.g
    fun1()->fun2()->fun3()->fun4()->fun5()->fun6()

Can i change this method invocation sequence to a custom sequence
using *only* loadable modules?

i.e
   fun1()->fun2()-->myfun1()-->myfun2()....->fun4()->fun5()->fun6().

And i do not want to replace any in kernel methods with my custom hooks.

Tried asking on kernelnewbies but i am not satisfied with the
debuggers pointed as help(i.e kprobes).

Apologies if this is too trivial for you all.

Any help?

Thanks
--pradeep
