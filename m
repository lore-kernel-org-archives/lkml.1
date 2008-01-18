Return-Path: <linux-kernel-owner+w=401wt.eu-S1764236AbYARRma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764236AbYARRma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761736AbYARRmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:42:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:11880 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758742AbYARRmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:42:22 -0500
X-ExtLoop1: 1
From: "Sean Hefty" <sean.hefty@intel.com>
To: "'Hal Rosenstock'" <hrosenstock@xsigo.com>,
       "Roland Dreier" <rdreier@cisco.com>
Cc: <linux-kernel@vger.kernel.org>, <general@lists.openfabrics.org>
References: <ada7ii8xaao.fsf@cisco.com> <1200676232.1486.88.camel@hrosenstock-ws.xsigo.com>
Subject: RE: [ofa-general] InfiniBand/RDMA merge plans for 2.6.25
Date: Fri, 18 Jan 2008 09:42:23 -0800
Message-ID: <000001c859f9$7bc7f590$ff0da8c0@amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1200676232.1486.88.camel@hrosenstock-ws.xsigo.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-Index: AchZ9Q2J60YnsqjWR7ipQMHBhLQbBQAA6nMQ
X-OriginalArrivalTime: 18 Jan 2008 17:42:21.0032 (UTC) FILETIME=[7A1A1E80:01C859F9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Sean Hefty (6):
>>       IB/mad: Fix incorrect access to items on local_list
>
>It wasn't clear to me that this issue was ever really nailed. Was the
>loop on this closed ?

The error that this patches addresses is fairly obvious if you inspect the code.
There's a strong chance that the patch fixes the bug that was reported, but the
last I remember, they had trouble reproducing the crash to see if the patch
would indeed make it go away.

- Sean

