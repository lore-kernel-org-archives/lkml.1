Return-Path: <linux-kernel-owner+w=401wt.eu-S933304AbXHHPgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304AbXHHPgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 11:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936150AbXHHPfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 11:35:48 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:9435 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936141AbXHHPfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 11:35:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=LIL9ZNphZQy8Es56fIhtiRnpeOJtYK70N5wR0A1QOPz4aoCAuvKI7209QJTbl3YO++Snu6Ea86aGWO5ajX2yo8/GJ8PK7p91O/+t2EFSI33lD4DOg/LXDvxyLUIaAXrOK8t/0B/S65WDawCwPWJtpUHVJLKUovrhfg2DyaR9B9w=
Message-ID: <46B9E2CB.1020208@gmail.com>
Date: Thu, 09 Aug 2007 00:35:39 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 14/25] sysfs: Don't use lookup_one_len_kern
References: <m1k5s7jbh9.fsf_-_@ebiederm.dsl.xmission.com>	<m1fy2vjbf9.fsf_-_@ebiederm.dsl.xmission.com>	<m1bqdjjbcf.fsf_-_@ebiederm.dsl.xmission.com>	<m17io7jba4.fsf_-_@ebiederm.dsl.xmission.com>	<m13ayvjb82.fsf_-_@ebiederm.dsl.xmission.com>	<m1y7gnhwm4.fsf_-_@ebiederm.dsl.xmission.com>	<m1tzrbhwkc.fsf_-_@ebiederm.dsl.xmission.com>	<m1ps1zhwhp.fsf_-_@ebiederm.dsl.xmission.com>	<m1lkcnhwfu.fsf_-_@ebiederm.dsl.xmission.com>	<m1hcnbhwcy.fsf_-_@ebiederm.dsl.xmission.com>	<20070808083815.GG13674@htj.dyndns.org> <m1ir7qdp3b.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ir7qdp3b.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>> right?  I don't think we need to duplicate the code here.  Or is it
>> needed for later multi-sb thing?
> 
> Right.  We can do that as well. In practice in working code
> there is no real difference.
> 
> There is a little extra uniformity in rolling it ourselves, but
> not enough to worry about either way.
> 
> In the review/debug etc cycle it just wound up being a lot easier
> to roll the code myself.
> 
> By the time we get to lookup_one_len_kern it is almost impenetrable
> code in namei.c where sysfs_add_dentry tends is easier to comprehend,
> and to modify for debugging.

Yeap, agreed.  I agreed with this one too in the comment for the next
patch.  I guess I should have wrote here too.  Sorry about the trouble.

Thanks.

-- 
tejun
