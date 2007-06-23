Return-Path: <linux-kernel-owner+w=401wt.eu-S1755077AbXFWIW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbXFWIW1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 04:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbXFWIWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 04:22:20 -0400
Received: from barikada.upol.cz ([158.194.242.200]:52412 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbXFWIWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 04:22:19 -0400
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andi Kleen <ak@suse.de>, lkml <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>
Subject: NAK (bashizm in the /bin/sh script): [PATCH v3] doc/oops-tracing: add Code: decode info
In-Reply-To: <20070622132810.3c758590.randy.dunlap@oracle.com>
References: <20070621225108.bb69a93d.randy.dunlap@oracle.com> <200706221626.39969.ak@suse.de> <20070622094429.0910c7cb.randy.dunlap@oracle.com> <200706221923.02736.ak@suse.de> <20070622132810.3c758590.randy.dunlap@oracle.com>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: jed (x86_64-pc-linux-glibc-debian)
X-Mailer: slrn
Date: Sat, 23 Jun 2007 10:34:59 +0200
Message-Id: <E1I2159-0005AH-DS@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* From: Randy Dunlap
* Newsgroups: linux.kernel
* Date: Fri, 22 Jun 2007 13:28:10 -0700
* Organization: Oracle Linux Eng.

[]
> --- /dev/null
> +++ linux-2.6.22-rc5/scripts/decodecode
> @@ -0,0 +1,47 @@
> +#!/bin/sh
> +# Disassemble the Code: line in Linux oopses
> +# usage: decodecode < oops.file

|-*- sh = dash -*-
flower:-$ <kernelOops.txt sh decodecode
Jun 18 22:05:11 localhost kernel: Code: 00 00 00 eb 1b 6b 4e 38 05 89 ca 03 53 \
1c 4a 89 d0 31 d2 f7 f1 89 da 89 c1 89 f0 e8 83 ed ff ff e8 26 af 12 00 8b 76 6\
4 83 ee 64 <8b> 46 64 0f 18 00 90 81 fe 14 5c 37 c0 0f 85 70 ff ff ff b8 84
decodecode: 31: Syntax error: Bad substitution
flower:-$
|-*-

Or you are writing for "#!/bin/bash", or i can help optimize and make
this script "sh" compatible.

NAK.
--
  frenzy
-o--=O`C
 #oo'L O
<___=E M
