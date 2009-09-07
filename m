Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbZIGNyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbZIGNyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 09:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264AbZIGNye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 09:54:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245AbZIGNye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 09:54:34 -0400
Message-ID: <4AA51065.6050000@redhat.com>
Date: Mon, 07 Sep 2009 09:53:41 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Ryo Tsuruta <ryov@valinux.co.jp>
CC: vgoyal@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       jens.axboe@oracle.com, agk@redhat.com, akpm@linux-foundation.org,
       nauman@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com
Subject: Re: Regarding dm-ioband tests
References: <20090901165011.GB3753@redhat.com>	<20090904.130228.104054439.ryov@valinux.co.jp>	<20090904231129.GA3689@redhat.com> <20090907.200222.193693062.ryov@valinux.co.jp>
In-Reply-To: <20090907.200222.193693062.ryov@valinux.co.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryo Tsuruta wrote:

> However, if you want to get fairness in a case like this, a new
> bandwidth control policy which controls accurately according to
> assigned weights can be added to dm-ioband.

Are you saying that dm-ioband is purposely unfair,
until a certain load level is reached?

> We regarded reducing throughput loss rather than reducing duration
> as the design of dm-ioband. Of course, it is possible to make a new
> policy which reduces duration.

... while also reducing overall system throughput
by design?

Why are you even bothering to submit this to the
linux-kernel mailing list, when there is a codebase
available that has no throughput or fairness regressions?
(Vivek's io scheduler based io controler)

-- 
All rights reversed.
