Return-Path: <linux-kernel-owner+w=401wt.eu-S1763554AbYD1BaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763554AbYD1BaZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 21:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbYD1BaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 21:30:12 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:25233 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbYD1BaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 21:30:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=dzUOrYpbYKlYVSEdTB+YCKeo/n6izr9XXkao39N+w9Ov55LW/unMNYO+hqmYhoOBMXYl24W6lqn/khbAHWkxBjGIfycxj/LxJ04CRBtllDBfG85WPkg5MrS7BcIif8oO/vHJSHT/A3WbX+aNVt6sRFbFG2H4LitE6WkqbzlSk40=
Message-ID: <dd18b0c30804271830hbaeb040jbccdab223551a952@mail.gmail.com>
Date: Mon, 28 Apr 2008 01:30:10 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: atheros failes to compile
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the latest git I can't seem to compile madwifi, (if ath5k has
support for my card I would use that, but not until later in time)
here is what I'm getting:

/home/name/Desktop/madwifi-trunk-r3574-20080426/Makefile:50
Makefile.inc: no such file or directory

 /*editing Makefile with the path to Makefile.inc produces this */

Makefile.inc98: scripts/get_arch.mk: no such file or directory
Makefile.inc:102 ath_hal/ah_target.inc: no such file or directory
Makefile.inc:163 *** TARGET i386-elf is invalid, invalid target are: . Stop.
make[1] *** [modules] Error 2
make[1] Leaving directory `/home/kernel/linux-2.6'
make *** [modules] Error 2

I've tried "y" to Allow gcc to uniline functions marked `inline' but
still am receiving the same results

If somebody has a suggestion to what I might add to my .config, or
subtract to my .config I'm open to suggestions.
luckily I'm still able to connect using ndiswrapper...
regards;


-- 
Justin P. Mattock
