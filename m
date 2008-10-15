Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbYJOVbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbYJOVbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 17:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbYJOVbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 17:31:23 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:34546 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbYJOVbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 17:31:22 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Christoph Hellwig <hch@infradead.org>, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] vfs: add __d_instantiate() helper
References: <fcaad2cb3e848f5f6f1126623.ps@mail.parknet.co.jp>
	<e015bca83e848f5f6f2226623.ps@mail.parknet.co.jp>
	<7754d3f83e848f5f6f2326623.ps@mail.parknet.co.jp>
	<20081015194119.GA24892@infradead.org>
	<87wsg9oan7.fsf@devron.myhome.or.jp>
	<1224103667.7371.44.camel@localhost>
Date: Thu, 16 Oct 2008 06:31:18 +0900
In-Reply-To: <1224103667.7371.44.camel@localhost> (Trond Myklebust's message
	of "Wed, 15 Oct 2008 16:47:47 -0400")
Message-ID: <87bpxlo89l.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust <Trond.Myklebust@netapp.com> writes:

>> Trond, do you care the following convert? E.g.
>> 
>> in d_materialise_unique():
>> 
>> from
>> 		dentry->d_inode = NULL;
>> 		goto found_lock;
>> to
>> 		__d_instantiate(dentry, NULL);
>> 		goto found_lock;
>
> That would be fine by me.

Thanks. I'll replace those.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
