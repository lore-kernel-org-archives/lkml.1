Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbYJPDaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbYJPDaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 23:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbYJPDaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 23:30:03 -0400
Received: from cnmailgate04.alcatel-sbell.com.cn ([211.144.215.47]:45588 "EHLO
	cnshjsmin03.cn.alcatel-lucent.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751783AbYJPDaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 23:30:01 -0400
X-AuditID: ac189297-a977ebb000000fe5-ad-48f6b5094393
Message-ID: <48F6B51B.2000408@alcatel-lucent.com>
Date: Thu, 16 Oct 2008 11:29:31 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: how to limit number of sectors each time
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Oct 2008 03:29:20.0029 (UTC) FILETIME=[6034D4D0:01C92F3F]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I want to limit requested sectors each time in function 
drivers/ide/ide-disk.c::__ide_do_rw_disk. The requested
sectors were defined in rq->nr_sectors. So how to limit or decrease 
nr_sectors for data transfer each time?

Thanks in advance,
Gavin
