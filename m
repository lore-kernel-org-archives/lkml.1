Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbXKDTmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbXKDTmP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 14:42:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbXKDTmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 14:42:00 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:49506 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbXKDTmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 14:42:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Wv9sFRn0XO0GqNUszaK3oPwITl9hh/wCZT+uMEzw9AG5pqgqNwoKqg73cVYt2mFSWOFJKRTtUFtJw49EpcgfYicaXQZpn/ARlb6wowz9dgotspfoh2TyNKbG6sAE3Spc+nuwCR2CESftIHDAZdksc56hpBSBmbTjZAKJQTq7Q3M=
Message-ID: <e5bfff550711041141h612a24cdrcdb5baa35907989d@mail.gmail.com>
Date: Sun, 4 Nov 2007 20:41:59 +0100
From: "Marco Costalba" <mcostalba@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: duplicated include files
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

make includecheck does not work for me. Linux tree is from latest git.

bash-3.2$ pwd
/git/linux-2.6

bash-3.2$ make includecheck
find * \( -name SCCS -o -name BitKeeper -o -name .svn -o -name CVS -o
-name .pc -o -name .hg -o -name .git \) -prune -o \
                -name '*.[hcS]' -type f -print | sort \
                | xargs perl -w scripts/checkincludes.pl
Can't open perl script "scripts/checkincludes.pl": No such file or directory
make[1]: *** [includecheck] Error 123
make: *** [sub-make] Error 2

bash-3.2$ ls scripts/checkincludes.pl
scripts/checkincludes.pl
