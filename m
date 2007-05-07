Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbXEGGfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbXEGGfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 02:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbXEGGfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 02:35:52 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:7090 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbXEGGfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 02:35:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bLIDWJQfUHt9C7LKamCgYzzuRxicLXI+Z5CuyDRNMBDqO6oPpISXoF8bCfmN8wGDnQiwyz++Bj/b9gKsixdulnM5di7uhhVVpssnv3vWjaMhdkkKzgxBk6Gc0HH5B377a8gSOLIkqC0MANJ5AoTI94BilKo9Q94S6X00Qg2rxSs=
Message-ID: <a781481a0705062335j5123a7ffs79cfaba4ef68f16f@mail.gmail.com>
Date: Mon, 7 May 2007 12:05:50 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Tom Zanussi" <zanussi@comcast.net>
Subject: Re: [PATCH] relay: use plain timer instead of delayed work
Cc: akpm@linux-foundation.org, oleg@tv-sign.ru, linux-kernel@vger.kernel.org
In-Reply-To: <1178508691.4534.4.camel@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1178426780.29337.67.camel@ubuntu>
	 <a781481a0705060310h3a9cb49asbbc8b7f5ddb38a8e@mail.gmail.com>
	 <1178508691.4534.4.camel@ubuntu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/07, Tom Zanussi <zanussi@comcast.net> wrote:
> [...]
> Thanks for your comments - I've updated the patch to include timer.h but
> wait.h would still be needed for wait_queue_head_t, so will leave that
> in.

Whoops ... I'd actually meant to say workqueue.h there, but perhaps
must've got confused on not finding any workqueue.h in relay.h at all
and so accidentally mentioned wait.h instead.

Thanks,
Satyam
