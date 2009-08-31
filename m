Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbZHaQlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbZHaQlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 12:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbZHaQlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 12:41:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:27568 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbZHaQlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 12:41:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,306,1249282800"; 
   d="scan'208";a="546392909"
Message-ID: <4A9BFD2C.90302@linux.intel.com>
Date: Mon, 31 Aug 2009 18:41:16 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Dave Hansen <haveblue@us.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Valerie Aurora <vaurora@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH mmotm] vfs: optimize touch_time too fix
References: <Pine.LNX.4.64.0908311558220.4384@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0908311558220.4384@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> Recent mmotms give me WARNING: at fs/namespace.c:612 mntput_no_expire()+...
> when unmounting: __mntput()'s WARN_ON(count_mnt_writers(mnt)).

Oops. Strange I ran my system quite some time with the patches
and didn't see these warnings.

Thanks Hugh.

-Andi

