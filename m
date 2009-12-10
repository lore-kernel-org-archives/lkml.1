Return-Path: <linux-kernel-owner+w=401wt.eu-S1761403AbZLJSQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761403AbZLJSQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 13:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761380AbZLJSP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 13:15:59 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:63624 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761295AbZLJSP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 13:15:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Zwjum6HxB+t9P+kCSCPO3xrR2OkxSGdJY9bwOiwPFmLvJaY26lKkjTokVOu/kv36oO
         r/fOVLVGTrJZBWTyzKzAFk3F+s4P7txlUMuVnNTBzNe9zW5bZ3pYezCnEorCi12VsO6c
         aYXPXpPGTKlapVPnN4GsbFVhfw2EJgqPl1ENE=
Message-ID: <4B213ADD.6010200@gmail.com>
Date: Thu, 10 Dec 2009 19:15:57 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091203 Fedora/3.0-3.13.rc2.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: phoronix test,  openssl bad performance
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

In the openssl test, Solaris is 2.4X times faster than Linux.

The hardware was:
ThinkPad T61 with Intel Core 2 Duo T9300 + 2GB RAM

OS (all 32-bit):
Build 127 of OpenSolaris 2010.02 with 5.11 kernel + GCC 4.3.2
Fedora 12 Linux 2.6.31 kernel + GCC 4.4.2
Ubuntu 9.10 Linux 2.6.31 kernel + GCC 4.4.1

"All operating systems were left with their default options during
the installation process and left with the default set of packages
for each operating system except for the obvious need to install
some dependencies for the different tests."

In Linux, it means AppArmor/SELinux and audit enabled, and etc...

the test:
openssl-0.9.8k, compiled with ./config no-zlib; make
command: $ openssl speed rsa4096 -multi $NUM_CPU_CORES


results: http://www.phoronix.com/data/img/results/freebsd8_benchmarks/20.png

Solaris     72.67 sign/s
Linux     ~=30    sign/s
(FreeBSD    20.3  sign/s)


complete article at http://www.phoronix.com/scan.php?page=article&item=freebsd8_benchmarks

-thanks-
