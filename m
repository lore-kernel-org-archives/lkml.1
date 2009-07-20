Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbZGTJyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbZGTJyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 05:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbZGTJyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 05:54:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51067 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbZGTJyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 05:54:39 -0400
Message-ID: <4A643EFE.7090103@cn.fujitsu.com>
Date: Mon, 20 Jul 2009 17:55:10 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Pavel Machek <pavel@ucw.cz>, mingo@elte.hu, tglx@linutronix.de,
       hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] Add function to convert between calendar time and
 broken-down time for universal use
References: <4A5C3BC0.6020701@cn.fujitsu.com>	<20090714151040.b7b3b26d.akpm@linux-foundation.org>	<20090718115019.GH1433@ucw.cz>	<04e101ca08e5$be078fa0$808410ac@zhaoleiwin> <20090719202018.497f7ec1.akpm@linux-foundation.org>
In-Reply-To: <20090719202018.497f7ec1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew

This is Patch v3.
I decide to use a struct instead of argument list to store year/mon/.../yday.

Changelog v2->v3:
Using a struct to save year/mon/.../yday.

Changelog v1->v2:
1: Fix "no tabs" error caused by email client.
2: Remove explicit 'inline' in __isleap()
3: Move DIV() and LEAPS_THRU_END_OF(y) into regular C function along with
   comment
4: Move gmtime() and localtime() into header file.

Thanks
Zhaolei

