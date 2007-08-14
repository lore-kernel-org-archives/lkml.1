Return-Path: <linux-kernel-owner+w=401wt.eu-S1763001AbXHNOi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763001AbXHNOi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 10:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760987AbXHNOiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 10:38:12 -0400
Received: from cm135.gamma145.maxonline.com.sg ([202.156.145.135]:43038 "EHLO
	kerndev.sin.redhat.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760352AbXHNOiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 10:38:10 -0400
Date: Tue, 14 Aug 2007 22:38:07 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Adnan Khaleel <akhaleel2001@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: Page Cache Question
Message-ID: <20070814143807.GA23257@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
References: <725937.57185.qm@web33705.mail.mud.yahoo.com> <46C18068.7020602@aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C18068.7020602@aitel.hist.no>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

<quote sender="Helge Hafting">
> Adnan Khaleel wrote:
>> I'm looking for a way to disable the page cache for an
>> experimental NUMA system running the 2.6.17 kernel. I would prefer to
>> only disable the page cache for my process and still have it be enabled
>> by the rest of the system. Is there an easy way of doing this?
>> Alternatively, I would be fine disabling the Page Cache altogether as 
>> well.
>>   
> Assuming what you really mean is that you don't want to cache
> file i/o for that process - try opening files with O_DIRECT.

You will probably find this tool useful:
http://userweb.kernel.org/~akpm/pagecache-management/

"... a little tool which permits the management of the pagecache usage of
arbitrary applications.  Effectively it prevents the targetted application
from using any pagecache at all."

Eugene
