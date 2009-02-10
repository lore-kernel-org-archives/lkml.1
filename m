Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbZBJCSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbZBJCSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 21:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbZBJCSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 21:18:36 -0500
Received: from omr2.networksolutionsemail.com ([205.178.146.52]:50197 "EHLO
	omr2.networksolutionsemail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751837AbZBJCSf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 21:18:35 -0500
From: "Gary L. Grobe" <gary@grobe.net>
To: "Gary L. Grobe" <gary@grobe.net>, "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
Importance: Normal
Sensitivity: Normal
Message-ID: <W322075763216621234232313@webmail8>
X-Mailer: Network Solutions Webmail, Build 11.2.30
X-Originating-IP: [139.169.174.136]
X-Forwarded-For: [(null)]
Date: Tue, 10 Feb 2009 02:18:33 +0000
Subject: Re:   processes in D state too long too often
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>The more likely explanation is that you just switched to a more recent
>>distro where "sync" (as opposed to "async") is the option.  Depending on
>>workload, "async" may improve performance a great deal, at the expense
>>of possible data corruption on server reboot!
>>
>>If you're doing a lot of writing and using NFSv2, then switching to
>>NFSv3 may give you performance close to the "async" performance without
>>the corruption worries.

Just a small update about our rollback I need to correct. Turns out our problem has been solved by going with the 2.6.20-r10 of the gentoo-sources patched kernel. Although gentoo marks this as unstable for amd64, it's working fine. I've made no other changes than going back a few versions on the kernel and adjusting the .config w/ the same settings. 

Tomorrow I'll likely give the next marked stable patched gentoo-sources kernel another try which was 2.6.24-r10 and recheck my configs and try to gather anything else I can gather from it.


