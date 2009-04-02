Return-Path: <linux-kernel-owner+w=401wt.eu-S1762349AbZDBHRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762349AbZDBHRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 03:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbZDBHQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 03:16:55 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:37628 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbZDBHQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 03:16:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=sbXd8cMy9pQuuFE6+v3DbooNUDwRdKBJz6LS1ETDDxh1zn2SHrwdv1E7k7MBxv+OqI
         9bEnG1FlpMY+m33kfM0R5X7XwyRUFE1l42Rms37M/MJr4aFYVd2YeEl3PzH5pPTBsDug
         Fb5tFxS4oTmR0PlUSmJ7aYG56yWeEB15DkCfY=
MIME-Version: 1.0
Date: Thu, 2 Apr 2009 09:16:51 +0200
Message-ID: <2d05c4580904020016o44801253p441ff9739aae74da@mail.gmail.com>
Subject: Kernel versions
From: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have noticed that when compiling various kernel versions with same
.config file
(this is .config file from generic 2.6.27-7 kernel that works)
on same machine the results are unpredictable :) Sometimes machine just
shuts down during the compilation, and in most cases it won't boot. I am always
downloading kernel sources from official site and I think these are
stable versions.
For example, 2.6.27.7 , 2.6.27.21 etc.

I am compiling kernel and modules with:

make
make modules
make modules_install
make install

and then run in /boot folder

mkinitrd initrd.img-2.6.27.21 2.6.27.21

and modify /boot/grub/menu.lst

So, is there some convention or practice, to know which versions are
stable or do
different distribution have something to do with it ?

thanks,

Dragoslav Zaric
[Professional programmer, MSc in Astrophysics]
