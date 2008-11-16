Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbYKPWol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbYKPWol (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 17:44:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbYKPWoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 17:44:21 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:20538 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbYKPWoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 17:44:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=KR5r+2wbhuIqO9vYIDd9dUo+PzIP6uq0ttieWD24+qf4imcLg3eqCdQeYmZss4GpO0
         S1a3EuNGdmkSuu7VpjuMfaXEY35jRsXK/4UpilVvmyd5SoGsr0QYHK7kZuhm7vaXa8UG
         BUwtC9PZbgZn9MZTMVhPI0BOcT6I1e5sJAoKs=
Subject: RTC problem in PS3
From: Fabiano Manoel de Andrade <fabianoma@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sun, 16 Nov 2008 20:44:50 -0200
Message-Id: <1226875490.6597.11.camel@lottar>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi I've compiled the latest version of linux kernel (2.6.27.6) in my
PS3 running debian and get a warning message listed here

	Setting the system clock.
  	Cannot access the Hardware Clock via any known method.
  	Use the --debug option to see the details of our search for an access method.
  	* Unable to set System Clock to: Sun Nov 16 20:33:06 UTC 2008


	The problem can be reproduced with the commands

	# hwclock --debug
 	hwclock from util-linux-ng 2.13.1.1
  	hwclock: Open of /dev/rtc failed, errno=2: No such file or directory.
  	No usable clock interface found.
  	Cannot access the Hardware Clock via any known method.
  	# ls -l /dev/rtc*
  	ls: cannot access /dev/rtc*: No such file or directory

	Loading the rtc-ppc module solve the problem, but after restart
the system I still have the problem. Looking at kernel config I change the
rtc-ppc to be build into kernel and this solve totally the problem. So the
ps3_defconfig must set the rtc-ppc to be build into kernel.

	Thanks in advance.
	Fabiano.




