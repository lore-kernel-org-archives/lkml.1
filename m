Return-Path: <linux-kernel-owner+w=401wt.eu-S1760059AbXHVJlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059AbXHVJlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbXHVJlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 05:41:06 -0400
Received: from ns2.tasking.nl ([195.193.207.10]:1464 "EHLO ns2.tasking.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbXHVJlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 05:41:04 -0400
X-Greylist: delayed 773 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Aug 2007 05:41:04 EDT
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
X-Newsreader: knews 1.0b.1
Reply-To: dick.streefland@altium.nl (Dick Streefland)
Organization: Altium BV
X-Face: "`*@3nW;mP[=Z(!`?W;}cn~3M5O_/vMjX&Pe!o7y?xi@;wnA&Tvx&kjv'N\P&&5Xqf{2CaT 9HXfUFg}Y/TT^?G1j26Qr[TZY%v-1A<3?zpTYD5E759Q?lEoR*U1oj[.9\yg_o.~O.$wj:t(B+Q_?D XX57?U,#b,iM$[zX'I(!'VCQM)N)x~knSj>M*@l}y9(tK\rYwdv%~+&*jV"epphm>|q~?ys:g:K#R" 2PuAzy-N9cKM<Ml/%yPQxpq"Ttm{GzBn-*:;619QM2HLuRX4]~361+,[uFp6f"JF5R`y
References: <20070821071938.GA17761@localhost.sw.ru> <9a8748490708210256v31a0ca00oa0d83dc401aeb98f@mail.gmail.com> <20070821231533.GE21089@ftp.linux.org.uk> <9a8748490708211702q7ed2649ft978cea8ab07b63fa@mail.gmail.com> <9a8748490708211702q7ed2649ft978cea8ab07b63fa@mail.gmail.com> <20070822005236.GF21089@ftp.linux.org.uk>
From: dick.streefland@altium.nl (Dick Streefland)
Subject: Re: [PATCH] ver_linux is [censored]
Content-Type: text/plain; charset=us-ascii
NNTP-Posting-Host: 172.17.1.66
Message-ID: <3cbe.46cc01a9.1e88c@altium.nl>
Date: Wed, 22 Aug 2007 09:28:09 -0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ftp.linux.org.uk> wrote:
| or, simpler yet,
| 
| sed -n -e '/^.*\/libc-\([^/]*\)\.so$/{s//\1/;p;q}' </proc/self/maps

Or:

sed -n 's/^.*\/libc-\([^/]*\)\.so$/\1/p; T; q' < /proc/self/maps

-- 
Dick Streefland                      ////                      Altium BV
dick.streefland@altium.nl           (@ @)          http://www.altium.com
--------------------------------oOO--(_)--OOo---------------------------

