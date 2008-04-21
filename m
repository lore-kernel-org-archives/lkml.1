Return-Path: <linux-kernel-owner+w=401wt.eu-S1757710AbYDUXXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbYDUXXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 19:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbYDUXXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 19:23:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbYDUXXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 19:23:11 -0400
Date: Tue, 22 Apr 2008 01:23:08 +0200
From: Karel Zak <kzak@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: [ANNOUNCE] util-linux-ng 2.13.1.1 (security update)
Message-ID: <20080421232308.GB3249@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The stable util-linux-ng 2.13.1.1 release is available at

    ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.13/


(Note, 2.13.1.1 is a stable security release.)

Feedback and bug reports, as always, are welcomed.


	Karel


Util-linux-ng 2.13.1.1 Release Notes (22-Apr-2008)
==================================================

Fixed security issue:
--------------------

 - audit log injection attack. This bug allows attackers to write
   arbitrary characters to an audit log via a crafted username.

 The problem was originally reported for OpenSSH few months ago
 (CVE-2007-3102). The login(1) is affected by the same bug when
 built with the option "--with-audit".


Changelog:
---------

 For more details see ChangeLog files at:
 ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.13/


login:
   - audit log injection attack via login  [Steve Grubb]
po:
   - merge changes  [Karel Zak]
   - update it.po (from translationproject.org)  [Marco Colombo]
   - update nl.po (from translationproject.org)  [Benno Schulenberg]

-- 
 Karel Zak  <kzak@redhat.com>
