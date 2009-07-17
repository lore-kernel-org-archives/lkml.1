Return-Path: <linux-kernel-owner+w=401wt.eu-S1757757AbZGQFEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757AbZGQFEF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 01:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757736AbZGQFEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 01:04:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:56876 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757732AbZGQFED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 01:04:03 -0400
Message-ID: <4A60062E.8090406@kernel.org>
Date: Fri, 17 Jul 2009 14:03:42 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Xiaotian Feng <dfeng@redhat.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] block: slightly optimize blkdev_ioctl BLKRA{SET,GET}
References: <1247572395-24021-1-git-send-email-dfeng@redhat.com> <1247580737-24713-1-git-send-email-dfeng@redhat.com>
In-Reply-To: <1247580737-24713-1-git-send-email-dfeng@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 17 Jul 2009 05:03:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiaotian Feng wrote:
> Slightly optimize blkdev_ioctl by using shift instead of multiply
> and divide.
> 
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>

As other people have commented, this is unnecessary.  Let's leave it
to the compiler.

Thanks.

-- 
tejun
