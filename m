Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbYI2PGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbYI2PGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 11:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbYI2PGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 11:06:06 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:12987 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbYI2PGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 11:06:03 -0400
To: device-mapper development <dm-devel@redhat.com>
Cc: martin.petersen@oracle.com, k-ueda@ct.jp.nec.com, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, agk@sourceware.org
Subject: Re: [dm-devel] [PATCH 2/2] dm: Add support for data integrity to DM
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20080920211433.9e1a6872.akpm@linux-foundation.org>
	<1222195272-18674-3-git-send-email-martin.petersen@oracle.com>
	<20080923.152942.41629825.k-ueda@ct.jp.nec.com>
Date: Mon, 29 Sep 2008 11:05:02 -0400
In-Reply-To: <20080923.152942.41629825.k-ueda@ct.jp.nec.com> (Kiyoshi Ueda's message of "Tue\, 23 Sep 2008 15\:29\:42 -0400 \(EDT\)")
Message-ID: <yq163off0wx.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Kiyoshi" == Kiyoshi Ueda <k-ueda@ct.jp.nec.com> writes:

Kiyoshi> Creating another function (e.g. dm_table_set_integrity(t,
Kiyoshi> md)) may be better, since then you wouldn't need dm_queue()
Kiyoshi> nor need to change the function interface of
Kiyoshi> dm_table_set_restrictions() I think.

You are right.  Originally I had more reasons for having that calling
interface change but that's no longer the case.  I'll fan the
integrity bits out to a separate function.

-- 
Martin K. Petersen	Oracle Linux Engineering

