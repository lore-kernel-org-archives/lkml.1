Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbYI3H6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbYI3H6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbYI3H5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:57:50 -0400
Received: from smtp.nokia.com ([192.100.105.134]:20798 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbYI3H5t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:57:49 -0400
Subject: Re: What is in ubifs-2.6.git
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: linux-fsdevel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org, Adrian Hunter <ext-adrian.hunter@nokia.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
References: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
Content-Type: text/plain; charset=utf-8
Date: Tue, 30 Sep 2008 10:56:23 +0300
Message-Id: <1222761383.8051.5.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 30 Sep 2008 07:56:36.0563 (UTC) FILETIME=[101DBA30:01C922D2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-09-30 at 12:18 +0300, Artem Bityutskiy wrote:
> addresses. For example, if user-space asks to read page zero of a
> file, and page 0-4 are in consecutive flash addressed, UBIFS reads
> pages 0-4 and populates them to the Page Cache.

Actually this example is a little wrong, because UBIFS starts
doing bulk-read only if few pages were read sequentially before.
So, user would have to read pages 0-3 sequentially, then UBIFS
would start doing bulk-read for this inode.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

