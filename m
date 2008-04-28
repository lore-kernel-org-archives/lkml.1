Return-Path: <linux-kernel-owner+w=401wt.eu-S932330AbYD1HOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330AbYD1HOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 03:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764112AbYD1HOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 03:14:15 -0400
Received: from smtp.nokia.com ([192.100.122.233]:48634 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbYD1HOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 03:14:15 -0400
Message-ID: <48157812.5090909@nokia.com>
Date: Mon, 28 Apr 2008 10:09:06 +0300
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: ext Christoph Hellwig <hch@infradead.org>
CC: Artem Bityutskiy <dedekind@yandex.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 26/26] UBIFS: include FS to compilation
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com> <1206629746-4298-27-git-send-email-Artem.Bityutskiy@nokia.com> <84144f020804010039n47133bd3l63f02258a2670e72@mail.gmail.com> <47F1F7A6.5020105@yandex.ru> <20080426093553.GA17730@infradead.org>
In-Reply-To: <20080426093553.GA17730@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Apr 2008 07:14:02.0101 (UTC) FILETIME=[6F828250:01C8A8FF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Christoph Hellwig wrote:
> On Tue, Apr 01, 2008 at 11:51:50AM +0300, Artem Bityutskiy wrote:
>>> But these don't make much sense to me. Why would you want to be able
>>> to compile out printks at this granularity? Why not enable all of them
>>> when CONFIG_UBIFS_FS_DEBUG is enabled?
>> Well, its just more convenient for us. If I know the bug is somewhere in
>> the journal, I enable the journal messages - less flooding. We may
>> lessen the amount, but it is still handy to have some classes of
>> prints separate.
> 
> It's everything but convenient :)  Please make it one config option to
> compile in all debug code and then have a module option to select the
> verbosity level at runtime.

Surely that judgement should be made by people who actually debug UBIFS.

