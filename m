Return-Path: <linux-kernel-owner+w=401wt.eu-S1751693AbXLYVu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbXLYVu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 16:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbXLYVuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 16:50:16 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:39257 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbXLYVuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 16:50:15 -0500
Date: Tue, 25 Dec 2007 16:50:04 -0500
Message-Id: <200712252150.lBPLo4wG031988@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: apw@shadowen.org, linux-kernel@vger.kernel.org
Subject: checkpatch false ERROR: trailing statements should be on next line
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using v2.6.24-rc6-125-g5356f66, code such as this:

	if (is_file)	/* dirs can be unlinked but chdir'ed to */
		err = -ESTALE;

produces this false checkpatch error:

	foo.c:947: ERROR: trailing statements should be on next line

I think comments such as the above should be allowed (plus a comment isn't a
statement).  It's often very useful to put them right on the affected line.

Thanks,
Erez.
