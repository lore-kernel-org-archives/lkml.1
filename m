Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbYHKSg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbYHKSg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbYHKSgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:36:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753035AbYHKSgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:36:46 -0400
Message-ID: <48A086B6.2000901@linux-foundation.org>
Date: Mon, 11 Aug 2008 13:36:38 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: lkml <linux-kernel@vger.kernel.org>
Subject: tbench regression on each kernel release from  2.6.22 -> 2.6.28
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that the network stack becomes slower over time? Here is a list of
tbench results with various kernel versions:

2.6.22		3207.77 mb/sec
2.6.24		3185.66
2.6.25		2848.83
2.6.26		2706.09
2.6.27(rc2)	2571.03

And linux-next is:

2.6.28(l-next)	2568.74

It shows that there is still have work to be done on linux-next. Too close to
upstream in performance.

Note the KT event between 2.6.24 and 2.6.25. Why is that?
