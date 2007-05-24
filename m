Return-Path: <linux-kernel-owner+w=401wt.eu-S1752239AbXEXSmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbXEXSmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 14:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbXEXSmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 14:42:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:29057 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbXEXSmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 14:42:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=A1/ewgsxQ/pVakPYjznbZEvBotc6OFVls+E3VJgBROcI3BPsQv27+85pxSezZGZwQEd78bELfPGAaxzTyb7m6CJAIgnSULvbrl4wz0NWImCYfy8QxHG/tw+5QZjYSn0OmKcVYl1eH7igEoCnrikDaZU4eG0Vha3MZZ+BH2m6RNE=
Message-ID: <df47b87a0705241142gce9bdbbkaa3b25be21ba04c0@mail.gmail.com>
Date: Thu, 24 May 2007 14:42:07 -0400
From: "Ioan Ionita" <opslynx@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, ak@suse.de
Subject: x86-64 2.6.22-rc2 random segfaults
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Since upgrading from 2.6.21 to 2.6.22-rc2, I started seeing some
segfaults in dmesg.
2.6.22-rc1-git2 even locked up on me at one point.

I'm using SLUB. I haven't yet found a way to easily reproduce the
problem.. Once I do, I'll try a git bisect

gam_server[4269]: segfault at 0000000000000018 rip 00002b46a9f88ab7
rsp 00007fff00d80020 error 4
gam_server[6003]: segfault at 0000000000000017 rip 00002accf4c50ab7
rsp 00007fffb60b74b0 error 4
gam_server[6395]: segfault at 0000000000000000 rip 00002b9f55885239
rsp 00007fff55754f30 error 4
gam_server[9414]: segfault at 000000000000001b rip 00002ab4a51b0ab7
rsp 00007fff05b59f60 error 4
gam_server[10412]: segfault at 000000000000001c rip 00002b7d42556ab7
rsp 00007fff687b14e0 error 4
gam_server[10427]: segfault at 0000000000000017 rip 00002ac59efe6ab7
rsp 00007fff0bd24130 error 4
gam_server[10433]: segfault at 0000000000000017 rip 00002b66058e9ab7
rsp 00007fffa5420710 error 4
gam_server[10451]: segfault at 0000000000000017 rip 00002b4220764ab7
rsp 00007fff8a5a3890 error 4
gam_server[10461]: segfault at 000000000000001d rip 00002ae292751ab7
rsp 00007fff185b69b0 error 4
gam_server[10485]: segfault at 000000000000001b rip 00002b525be5dab7
rsp 00007fff4eeab150 error 4
gam_server[10491]: segfault at 000000000000001a rip 00002aff730c7ab7
rsp 00007fff37c42eb0 error 4
root@ops-desktop:~# uname -a
Linux ops-desktop 2.6.22-rc2-git4 #1 SMP PREEMPT Wed May 23 22:35:02
EDT 2007 x86_64 GNU/Linux
