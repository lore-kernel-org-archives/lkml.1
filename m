Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbXLWBtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbXLWBtm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbXLWBte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:49:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:51028 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbXLWBtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:49:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:from;
        b=U0pK0ZvSX8hSrJHsK7bR5ht8w3/GtN2fTBc1aBK7tV6/mUElDI53EVkivJ9Jcrwfz91Gv/O+ME73E5wQf8pByiHlNRpZ0q2biW04FEyCmSrtLgGhW85S8BHxxEU37RAsuHu1kh1ylB+Md6O2+QA3CgmsHF0N5ifrkfpTPLov0/A=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 00/24] udf: convert super_block macros to functions 
Date: Sun, 23 Dec 2007 02:50:50 +0100
Message-Id: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.4
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
This patchset converts macros related to super_block handling into
functions. Besides that it fixes some sparse warnings (23rd and 24th),
improves coding style (1st) and fixes error handling (19th).

Note that udf files has really long lines and these patches won't validate
by checkpatch. I'm going to do more cleanups later.

PS: This is the first time I use git-send-email - tell me if I do something wrong.

Marcin Slusarz
