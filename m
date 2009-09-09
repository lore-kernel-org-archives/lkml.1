Return-Path: <linux-kernel-owner+w=401wt.eu-S1752447AbZIIHfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbZIIHfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 03:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbZIIHfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 03:35:04 -0400
Received: from lo.gmane.org ([80.91.229.12]:35337 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbZIIHfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 03:35:03 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Arkadiusz Miskiewicz <arekm@pld-linux.org>
Subject: Re: Linux 2.6.27.32
Followup-To: gmane.linux.kernel
Date: Wed, 09 Sep 2009 09:10:50 +0200
Message-ID: <h87kdq$us2$1@ger.gmane.org>
References: <20090909040829.GA9657@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 83.238.65.58
User-Agent: KNode/4.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

> I'm announcing the release of the 2.6.27.32 kernel.  All users of the
> 2.6.27 kernel series are very strongly encouraged to upgrade.

  CC [M]  fs/ocfs2/aops.o
fs/ocfs2/aops.c: In function 'ocfs2_write_cluster':
fs/ocfs2/aops.c:1286: error: 'should_zero' undeclared (first use in this 
function)
fs/ocfs2/aops.c:1286: error: (Each undeclared identifier is reported only 
once
fs/ocfs2/aops.c:1286: error: for each function it appears in.)
fs/ocfs2/aops.c: In function 'ocfs2_write_cluster_by_desc':
fs/ocfs2/aops.c:1360: warning: passing argument 4 of 'ocfs2_write_cluster' 
makes pointer from integer without a cast
fs/ocfs2/aops.c:1235: note: expected 'struct ocfs2_alloc_context *' but 
argument is of type 'unsigned int'
fs/ocfs2/aops.c:1360: warning: passing argument 6 of 'ocfs2_write_cluster' 
from incompatible pointer type
fs/ocfs2/aops.c:1235: note: expected 'struct ocfs2_write_ctxt *' but 
argument is of type 'struct ocfs2_alloc_context *'
fs/ocfs2/aops.c:1360: warning: passing argument 7 of 'ocfs2_write_cluster' 
makes integer from pointer without a cast
fs/ocfs2/aops.c:1235: note: expected 'u32' but argument is of type 'struct 
ocfs2_write_ctxt *'
fs/ocfs2/aops.c:1360: error: too many arguments to function 
'ocfs2_write_cluster'
make[2]: *** [fs/ocfs2/aops.o] Error 1

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

