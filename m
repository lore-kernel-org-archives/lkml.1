Return-Path: <linux-kernel-owner+w=401wt.eu-S1761449AbXHVJja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761449AbXHVJja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbXHVJjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 05:39:22 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:12461 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbXHVJjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 05:39:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Ydfzamxx97Xxvu3lhU5fpkIqnZmhQmje5ZuqHIMFtdVAD2d+Po1rVAF8szFCBf10JK1sTCzGgWEwcf1+aDTFwX+XF2ILn0Diw+n8dK+vt8H/MI6fULcfT6VF22RrqYxA/SjQaC12OlZK646S9JelBBzL8obgG7y7zOwzwVcwCfk=
Message-ID: <46CC043F.4090005@gmail.com>
Date: Wed, 22 Aug 2007 18:39:11 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: ebiederm@xmission.com, greg@kroah.com, linux-kernel@vger.kernel.org,
       satyam@infradead.org, stern@rowland.harvard.edu,
       containers@lists.osdl.org
Subject: Re: [PATCHSET] Sysfs cleanups from Eric W. Biederman
References: <11876133893720-git-send-email-htejun@gmail.com> <20070822112608.1645030c@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070822112608.1645030c@gondolin.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Mon, 20 Aug 2007 21:36:29 +0900,
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> Hello, all.
>>
>> This is subset of Eric W. Biederman's "Sysfs cleanups & tagged
>> directory support" patchset[1] with the following modifications.
>>
>> * fix-i_mutex-locking-in-sysfs_get_dentry patch is added at the top
>>   and #14-Don_t-use-lookup_one_len_kern and
>>   #15-vfs-Remove-lookup_one_len_kern are dropped.  This is because #14
>>   contained had a bug where it might created dentry/inode for an
>>   already deleted sysfs_dirent.  I think it's benefitial to keep
>>   single lookup path.
>>
>> * Rewrote simplify-sysfs_get_dentry patch and
>>   #08-Implement-__sysfs_get_dentry,
>>   #09-Move-sysfs_get_dentry-below-__sysfs_get_dentry and
>>   #10-Rewrite-sysfs_get_dentry-in-terms-of-__sysfs_get_dentry are
>>   omitted as __sysfs_get_dentry() isn't used by anyone.
>>
>> * #16, 19-25 are omitted as it isn't clear yet how the tagged entry
>>   support will end up.
>>
>> * readdir simplification fixed.
>>
>> * sysfs_mutex double locking fixed.
>>
>> The patchset is on top of the current -gregkh.
> 
> Survives some casual testing (including moving devices). Patches look
> sane to me at a cursory glance as well (sorry, don't have much time at
> the moment).

Thanks.

-- 
tejun
