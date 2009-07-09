Return-Path: <linux-kernel-owner+w=401wt.eu-S1761253AbZGIQxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761253AbZGIQxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 12:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757792AbZGIQxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 12:53:08 -0400
Received: from av10-2-sn2.hy.skanova.net ([81.228.8.182]:34621 "EHLO
	av10-2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757819AbZGIQxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 12:53:07 -0400
Message-ID: <4A56206A.5020601@mocean-labs.com>
Date: Thu, 09 Jul 2009 18:52:58 +0200
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1b3pre) Gecko/20090223 Thunderbird/3.0b2
MIME-Version: 1.0
To: linux-input@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, kwangwoo.lee@gmail.com,
       Thierry Reding <thierry.reding@avionic-design.de>,
       soni.trilok@gmail.com
Subject: [PATCH 0/1] tsc2007: Cancel work sync, increase polling frequency,
 make exit platform hw callback optional
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to be applied after my previous two for the
TSC2007.

I send it as a new patch, since my previous two are applied
to the -mm-tree.

The idea is to:
cancel the work using the _sync version, to make sure any
running "work" is finished.
Increase the polling frequency while the screen is touched,
to reduce the risk of missing taps.
Make the exit_platform_hw callback optional since it's not
needed on all platforms.

The changes are one-liners so they are all in one patch.

--Richard
