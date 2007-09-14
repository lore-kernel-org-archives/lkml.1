Return-Path: <linux-kernel-owner+w=401wt.eu-S1759152AbXINUBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152AbXINUBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 16:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756584AbXINUBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 16:01:11 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:49356 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756092AbXINUBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 16:01:10 -0400
Message-ID: <46EAE885.3080106@lwfinger.net>
Date: Fri, 14 Sep 2007 15:01:09 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Interpretation of sparse warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The code sequence

        u32 macstat;
.....
        macstat = le32_to_cpu(rxhdr->mac_status);

generates the following sparse warnings

drivers/net/wireless/b43legacy/xmit.c:446:12: warning: cast to restricted type
drivers/net/wireless/b43legacy/xmit.c:446:12: warning: cast from restricted type

(#446 is the macstat = ..... line)

My version of sparse is from the git tree and was downloaded today.

I think the code sequence is correct. What, if anything, should I do to eliminate the warning?

Thanks,

Larry


