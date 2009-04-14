Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbZDNJz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbZDNJz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbZDNJzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:55:14 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41894 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbZDNJzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:55:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Ls3BXHjjImS1aSfPwtrWzNLxyMir4NVPUhSfpKN3jRvjv49YgDp5lOubsyoojomkrT
         3NRyqwFk5KoAvmNvKFZ932Vy33rZNNNdAfxbsI+3rTsHUEjh2/9TZlrYFb01MCSPO59L
         USz24/hKF+NQ/Hb7Sx07aZeQs2f+1eyBKR914=
MIME-Version: 1.0
Date: Tue, 14 Apr 2009 11:55:10 +0200
Message-ID: <2d05c4580904140255t25414b2bpe99b2a150dbe132a@mail.gmail.com>
Subject: Fast testing
From: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Cyrill Gorcunov <gorcunov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have question regarding fast testing of some change in some kernel
source file. Since rebooting is a long process, there must be way to
test some change faster [of course only if source file is not some boot
connected file, but maybe this is also doable].

This is question:

When system is running, file that drives the system is "vmlinux" executable
and it is located in "/" or "/boot" folder. Let's say you change some kernel
source file and run "make" [this is fast since "make" should see that just few
files are changed]. After "make install" you should now have new "vmlinux" file.
Since state of cpu registers and memory locations determine current
system state, the change in binary system driver ["vmlinux"] should not
freeze system ? So if I copy new vmlinux over old vmlinux file can I see
change immediately ? I think it should continue to drive system without
problem because vmlinux is binary algorithm file, it does not contain any
data regarding current system state ? Also this assumes that your change does
not affect some large things, like memory segmentation tables and paging,
let's say it is more algorithmic and not structure change, because it is obvious
if you have structural change, current memory and register states
probably won't map
into new structure without system freeze.

Thanks,

Dragoslav Zaric,

[Programmer, M.Sc Astrophysics]
