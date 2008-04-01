Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbYDAJNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbYDAJNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 05:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754922AbYDAJNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 05:13:38 -0400
Received: from smtp.nokia.com ([192.100.122.230]:65102 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbYDAJNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 05:13:38 -0400
Message-ID: <47F1FBCF.2090902@yandex.ru>
Date: Tue, 01 Apr 2008 12:09:35 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>,
       penberg@cs.helsinki.fi, ext-adrian.hunter@nokia.com, jwboyer@gmail.com
Subject: Re: UBIFS vs Logfs (was [RFC PATCH] UBIFS - new flash file system)
References: <47F1EC20.6050600@wpkg.org> <47F1F644.4060000@yandex.ru> <20080401090309.GA7465@logfs.org>
In-Reply-To: <20080401090309.GA7465@logfs.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Apr 2008 09:13:26.0257 (UTC) FILETIME=[A486B610:01C893D8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> About a year ago I would have used roughly the same argument.  But in
> the meanwhile I have accepted the fact that any piece of flash I'll use
> in a notebook in the next five years will likely use SATA or USB as a
> transport medium.

Well, Thomasz was talking not about the transport I believe. If you have a
raw flash access via SATA or USB, then this is handled on the driver level
and does not any require FS support. JFFS2 or UBIFS may also work with such a
device, because it is just raw flash. But I know that you know that most of
the FTL-enabled stuff does not give use raw flash access.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
