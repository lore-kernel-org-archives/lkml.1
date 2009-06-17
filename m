Return-Path: <linux-kernel-owner+w=401wt.eu-S1753757AbZFQPWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbZFQPWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 11:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbZFQPWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 11:22:04 -0400
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:53338 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbZFQPWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 11:22:03 -0400
From: hooanon05@yahoo.co.jp
To: zohar@us.ibm.com
cc: linux-kernel@vger.kernel.org
Subject: Q. IMA and mark_files_ro()
Date: Thu, 18 Jun 2009 00:22:02 +0900
Message-ID: <9932.1245252122@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have a question about IMA.
IMA tracks file-open and open for read/write individually based upon
MAY_READ/WRITE or FMODE_READ/WRITE.
But FMODE_WRITE may be dropped by mark_files_ro() which is called by
emergency_remount().
In this case, 'readcount' and 'writecount' in IMA will be incorrect. And
IMA will produce wrong messages.

It may not be necessary to support such case (because it is
"emergency"), so I don't say it is a big problem. But I'd like to ask
whether it is an intended behaviour or not.

Thanks in advance
J. R. Okajima
