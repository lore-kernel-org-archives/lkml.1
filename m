Return-Path: <linux-kernel-owner+w=401wt.eu-S1757905AbZDIAnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905AbZDIAnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 20:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756071AbZDIAnC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 20:43:02 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58806 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756707AbZDIAnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 20:43:00 -0400
Message-ID: <49DD44B5.9040702@cn.fujitsu.com>
Date: Thu, 09 Apr 2009 08:43:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Christoph Hellwig <hch@infradead.org>, felixb@sgi.com,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: [PATCH 4/6] xfs: use memdup_user()
References: <49DC4CC0.9050805@cn.fujitsu.com>	<49DC4D54.3020001@cn.fujitsu.com>	<20090408132254.GA5957@infradead.org> <adabpr76oia.fsf@cisco.com>
In-Reply-To: <adabpr76oia.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > wouldn't NULL be a better error return for this kind of interface,
>  > matching kmalloc?
> 
> I guess returning an error code from memdup_user() lets callers
> distinguish between ENOMEM and EFAULT.  Not sure if that's important or
> not but there probably are at least some sites that care.
> 

Right, and this API is simlilar to strndup_user().
