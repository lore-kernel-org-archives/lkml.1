Return-Path: <linux-kernel-owner+w=401wt.eu-S1752135AbZLRG7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbZLRG7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 01:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbZLRG7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 01:59:19 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:33134 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbZLRG7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 01:59:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YQmVXD3MyDnLAslOoT/1vbRIB2olmiAFAZPzx226zcG1v6fsyr4NRg//eJfXYC3Ftx
         g+Lqna/qJTR4FVA8ahHl7TcP7ZKMqEOD97oBUNyhn5kYTEJT2ZIhdI17RSOyTFYLPOKx
         HbrMd7sF3uO4RULa1MlpChnTkE30RHFMsjm2s=
MIME-Version: 1.0
In-Reply-To: <4B2B1852.6080105@cn.fujitsu.com>
References: <4B2ADB4C.7010900@cn.fujitsu.com>
	 <9bd6b5360912172039y432361fu243d0f05bf75b7b7@mail.gmail.com>
	 <4B2B1852.6080105@cn.fujitsu.com>
Date: Fri, 18 Dec 2009 14:59:17 +0800
Message-ID: <9bd6b5360912172259x17ee93d6y631ab52988f8965a@mail.gmail.com>
Subject: Re: Re: [PATCH] btrfs: Simplify offset calculation method for ctree.h
From: sniper <s3c24xx@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/18 Zhaolei <zhaolei@cn.fujitsu.com>:
> sniper wrote:
>> No, many pointers in btrfs function arguments are not pointing to an
>> absolute address, but relative to the start address of extent.
>> Take following function as example, argument inode_item is an offset
>> value to the beginning of leaf. So we can't reach its member with
>> &inode_item->xxx
>
> Notice that we are not reach its member, we are getting pointer of its
> member with &inode_item->mtime.
> This operation have same effect as old one.

right!
