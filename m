Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbXL1PIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbXL1PIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 10:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbXL1PIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 10:08:22 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:60560 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbXL1PIV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 10:08:21 -0500
Date: Fri, 28 Dec 2007 16:08:19 +0100
Message-Id: <73443449@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: dl9pf@gmx.de
Subject: Re: kbuild: modules_install regression ? - depmod
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+AU//cS6O3xNTbcqeVKXtOHz83+AHOrhTaf/y6rGbvm60Mj
 h+OCo2B4mkQo9Kq5CpTmwltgS+zMyHcjOAvpsmlQQdHKu8c5Bw=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i have the same issue, but with 2.6.24-rc6 on a box with 512MB RAM

System is openSUSE 10.3

on "make modules_install" , depmod reproduceably dies with out of memory error when it is ~800MB VSZ and ~350MB RSS
this happens on different hardware.

any clue what`s going wrong?
how much memory should i expect being needed with "make modules_install" , e.g. with allmodconfig ?


Subject:    kbuild: modules_install regression ? - depmod
From:       Jan-Simon =?utf-8?q?M=C3=B6ller?= <dl9pf () gmx ! de>
Date:       2007-11-01 4:14:34
Message-ID: 200711010514.34469.dl9pf () gmx ! de
[Download message RAW]

Hi!

I compiled kernel 2.6.24-rc1 (latest git as of today) on a Box with 256MB Ram.
During "make modules_install" I got these errors:

  DEPMOD  2.6.24-rc1-default
WARNING: Can't read 
module /lib/modules/2.6.24-rc1-default/kernel/net/bridge/bridge.ko: Cannot 
allocate memory
WARNING: Can't read 
module /lib/modules/2.6.24-rc1-default/kernel/net/bridge/netfilter/ebt_redirect.ko: 
Cannot allocate memory
[...]
FATAL: Memory allocation failure depmod.c line 158: realloc(mod->deps, 
sizeof(mod->deps[0])*(mod->num_deps+1)).
make: *** [_modinst_post] Fehler 1


Depmod used too much memory and exits. Tried a 2nd time and checked with top.

IMHO this is a regression.

best regards
jan-simon

__________________________________________________________________________
Erweitern Sie FreeMail zu einem noch leistungsstärkeren E-Mail-Postfach!		
Mehr Infos unter http://produkte.web.de/club/?mc=021131

