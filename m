Return-Path: <linux-kernel-owner+w=401wt.eu-S1752814AbZGOHXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbZGOHXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 03:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbZGOHXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 03:23:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54879 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbZGOHXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 03:23:17 -0400
Message-ID: <4A5D83F6.8090101@cn.fujitsu.com>
Date: Wed, 15 Jul 2009 15:23:34 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@elte.hu, tglx@linutronix.de, hirofumi@mail.parknet.co.jp,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] Add function to convert between calendar time and
 broken-down time for universal use
References: <4A5C3BC0.6020701@cn.fujitsu.com> <20090714151040.b7b3b26d.akpm@linux-foundation.org>
In-Reply-To: <20090714151040.b7b3b26d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew

I modified this patch based on your review.
Here is changes:
1: Fix "no tabs" error caused by email client.
2: Remove explicit 'inline' in __isleap()
3: Move DIV() and LEAPS_THRU_END_OF(y) into regular C function along with
   comment
4: Move gmtime() and localtime() into header file.

Thanks
Zhaolei

