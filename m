Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbXD0RsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbXD0RsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 13:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbXD0RsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 13:48:15 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:59138 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbXD0RsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 13:48:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=JxKUMEfCBAO1x58xp6wtNnJRGpqEi6VAI3h0ZD3KCyaBQszwoVTN2hkTphiYrLPjGpWK5pru7DTIAivTn5MMAxQNgetc7bnrpEbttKFFApOIhqayQFUbQxV66hS3+HJwRyIQ+rFjlL1bIXt3tNhl64PU17LAX1Bjd2wWds7U+Ag=
Message-ID: <46323756.8080807@gmail.com>
Date: Sat, 28 Apr 2007 02:48:06 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm snapshot broken-out-2007-04-25-02-49.tar.gz uploaded
References: <200704250952.l3P9qIHh032233@shell0.pdx.osdl.net>	 <462FB8E6.9070501@googlemail.com> <463117DF.2020103@googlemail.com>	 <20070427001246.GB5303@suse.de> <6bffcb0e0704271038y7d099a7au7eae8a99b605cb2f@mail.gmail.com>
In-Reply-To: <6bffcb0e0704271038y7d099a7au7eae8a99b605cb2f@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
>> I've dropped the gregkh-driver-sysfs-* patches listed above from my tree
>> as Tejun is reworking the series to handle all of the different changes
>> that have been needed as they have been tested, so you shouldn't have to
>> worry about them.
>>
>> But I would be interested in finding out why the above is breaking for
>> you.
> 
> GOOD
> gregkh-driver-sysfs-reimplement-symlink-using-sysfs_dirent-tree.patch
> BAD

Thanks for bisecting.  I'm currently re-spinning sysfs rework patches
and the problem is fixed in new series.  I'll post it soon.

-- 
tejun
