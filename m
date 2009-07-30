Return-Path: <linux-kernel-owner+w=401wt.eu-S1751317AbZG3Fgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317AbZG3Fgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 01:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbZG3Fga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 01:36:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61570 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbZG3Fg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 01:36:29 -0400
Message-ID: <4A713204.7030005@cn.fujitsu.com>
Date: Thu, 30 Jul 2009 13:39:16 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Pavel Machek <pavel@ucw.cz>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] Add function to convert between calendar time and
 broken-down time for universal use
References: <4A5C3BC0.6020701@cn.fujitsu.com>	<20090714151040.b7b3b26d.akpm@linux-foundation.org>	<20090718115019.GH1433@ucw.cz>	<04e101ca08e5$be078fa0$808410ac@zhaoleiwin>	<20090719202018.497f7ec1.akpm@linux-foundation.org>	<4A643EFE.7090103@cn.fujitsu.com> <4A643F36.5090200@cn.fujitsu.com>	<87ocr9mi8h.fsf@devron.myhome.or.jp> <4A6D1BCF.1030109@cn.fujitsu.com>	<87k51u8xwa.fsf@devron.myhome.or.jp> <4A6E6ADD.6090602@cn.fujitsu.com> <87vdld9yrr.fsf@devron.myhome.or.jp>
In-Reply-To: <87vdld9yrr.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew

This is Patch v4.
I updated this patch bases on Ogawa-san's suggestion.

Changelog v3->v4:
1: Use long instead of int for tm.tm_year to avoid overflow
2: Remove localtime() and gmtime() because they can't support timezone
   database as user-more. And rename __offtime() to time_to_tm()
3: Use time_t instead of __kernel_time_t as function's argument type
4: __isleap(unsigned int year)->__isleap(long year) to avoid overflow

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

