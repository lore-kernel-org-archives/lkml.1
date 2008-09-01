Return-Path: <linux-kernel-owner+w=401wt.eu-S1759896AbYIALue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896AbYIALue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 07:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757511AbYIALuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 07:50:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:35288 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757215AbYIALuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 07:50:08 -0400
Subject: Re: [PATCH] UBIFS: fill f_fsid
From: David Woodhouse <dwmw2@infradead.org>
To: dedekind@infradead.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
In-Reply-To: <1220269436.4036.29.camel@sauron>
References: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
	 <1220194366-12731-13-git-send-email-dedekind@infradead.org>
	 <1220262187.2982.58.camel@pmac.infradead.org>
	 <1220267810.4036.24.camel@sauron>
	 <1220268480.2982.68.camel@pmac.infradead.org>
	 <1220269436.4036.29.camel@sauron>
Content-Type: text/plain
Date: Mon, 01 Sep 2008 12:50:04 +0100
Message-Id: <1220269804.2982.72.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-01 at 14:43 +0300, Artem Bityutskiy wrote:
> May be, but there are only 5 bytes left. 

There are 5 uint32_ts left. And then there would be 3.

> But why would you need more UUID bytes?

People are mostly using 16-byte UUIDs. We only have space to expose 8
bytes. It just seems to make sense to expose all 16.

But there's no overriding reason to do it, really.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



