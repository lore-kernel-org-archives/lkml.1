Return-Path: <linux-kernel-owner+w=401wt.eu-S1759613AbYIALr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613AbYIALr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 07:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbYIALrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 07:47:42 -0400
Received: from smtp.nokia.com ([192.100.122.233]:38703 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbYIALri convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 07:47:38 -0400
Subject: Re: [PATCH] UBIFS: fill f_fsid
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
In-Reply-To: <1220268480.2982.68.camel@pmac.infradead.org>
References: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
	 <1220194366-12731-13-git-send-email-dedekind@infradead.org>
	 <1220262187.2982.58.camel@pmac.infradead.org>
	 <1220267810.4036.24.camel@sauron>
	 <1220268480.2982.68.camel@pmac.infradead.org>
Content-Type: text/plain; charset=utf-8
Date: Mon, 01 Sep 2008 14:43:56 +0300
Message-Id: <1220269436.4036.29.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 01 Sep 2008 11:47:21.0300 (UTC) FILETIME=[7E3E3140:01C90C28]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-01 at 12:28 +0100, David Woodhouse wrote:
> > > Alternatively, there's space in the struct statfs to export a couple
> > > more uint32_ts, and thus the _whole_ of the uuid. Perhaps we should do
> > > that?
> > 
> > You mean f_spare? I do not think any application would use it so I doubt
> > it is good idea to use it.
> 
> Well, it wouldn't be called f_spare any more, and applications would
> know that it contains the rest of the UUID if it's non-zero.

May be, but there are only 5 bytes left. But why would you need more
UUID bytes?

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

