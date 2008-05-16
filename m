Return-Path: <linux-kernel-owner+w=401wt.eu-S1758048AbYEPQsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbYEPQsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbYEPQsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:48:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbYEPQr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:47:59 -0400
Date: Fri, 16 May 2008 12:47:40 -0400
From: Rik van Riel <riel@redhat.com>
To: "MinChan Kim" <minchan.kim@gmail.com>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH -mm 09/15] add some sanity checks to get_scan_ratio
Message-ID: <20080516124740.0bc11fd6@cuia.bos.redhat.com>
In-Reply-To: <28c262360805152342r57851584y888c1a4d08820eb2@mail.gmail.com>
References: <20080428181835.502876582@redhat.com>
	<20080428181852.961869151@redhat.com>
	<28c262360805142334y4740530co36ecd5c44752f1@mail.gmail.com>
	<20080515091230.6718cdb8@bree.surriel.com>
	<28c262360805152342r57851584y888c1a4d08820eb2@mail.gmail.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2008 15:42:59 +0900
"MinChan Kim" <minchan.kim@gmail.com> wrote:

> But you used argument with NR_ACTIVE_ANON during call shrink_list.
> I think It is not your intention.
> So, you have to change LRU_ACTIVE_ANON or call shrink_active_list directly.

I applied your fix to my tree.  Thank you.

(now to finish forward porting the whole thing and resubmitting it...)

-- 
All Rights Reversed
