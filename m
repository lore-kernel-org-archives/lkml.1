Return-Path: <linux-kernel-owner+w=401wt.eu-S1752716AbYIBLIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbYIBLIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 07:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbYIBLIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 07:08:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:60374 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbYIBLIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 07:08:42 -0400
Message-ID: <48BD1E30.8040602@kernel.org>
Date: Tue, 02 Sep 2008 13:06:24 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
CC: device-mapper development <dm-devel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Problem w/ CONFIG_DEBUG_BLOCK_EXT_DEVT
References: <48BD173B.3090600@hp.com> <48BD19B1.9040207@kernel.org> <48BD1BA5.1020604@hp.com>
In-Reply-To: <48BD1BA5.1020604@hp.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Sep 2008 11:07:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan D. Brunelle wrote:
>>> (2) Device minor numbers can be quite large, and the 10-character limits
>>> in dm/lib/libdm-deptree.c are too small.
>> Would it be difficult to increase that?
> 
> No, but knowing the upper bound would be helpful.

Well, dev_t is 32bits and MINORBITS is 20.  So, major 12 bits, minor 20
bits, so 4 characters for major, 7 characters for minor.

-- 
tejun
