Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbYAFAnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbYAFAnS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 19:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbYAFAnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 19:43:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:60133 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbYAFAnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 19:43:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:from;
        b=iDYoHeenlYVdRcJ9AiMYno94rhJSCfJnwpstJB7Pxa+l30R1IOaRz1cJmOVJf+2l/qiHE3xzyfQcTB74L/ew1TEk0n/2QUVB+EW7tpePlJeL1aRAQb38CGpkEcaBRkN1TU90GXjWPZtUX3CPj0+RM9EtY35LVpMi5AO2Vux8iG4=
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@infradead.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 0/6] udf: improve code related to super_block v3
Date: Sun,  6 Jan 2008 01:44:29 +0100
Message-Id: <1199580275-2487-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
This patchset converts macros related to super_block into
functions. Besides that it fixes some sparse warnings (6th),
improves coding style (1st) and fixes error handling (4th).

Note that udf files has really long lines and these patches won't
validate by checkpatch. Next patchset will clean it up almost completely.
(Only 3rd patch changed from second version)

Second version: http://lkml.org/lkml/2007/12/23/197
First version: http://lkml.org/lkml/2007/12/22/150

Marcin Slusarz
