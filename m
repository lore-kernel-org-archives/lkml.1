Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbZKKHmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbZKKHmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 02:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbZKKHml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 02:42:41 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:51712 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376AbZKKHml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 02:42:41 -0500
Message-ID: <4AFA6AEF.5060306@garzik.org>
Date: Wed, 11 Nov 2009 02:42:39 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, mingo@elte.hu,
       Frederic Weisbecker <fweisbec@gmail.com>, auke-jan.h.kok@intel.com
Subject: Re: [PATCH] vfs: Add a trace point in the mark_inode_dirty function
References: <20091025225342.007138f5@infradead.org>	<20091111020108.GA11423@localhost> <20091110223456.01ef355f@infradead.org>
In-Reply-To: <20091110223456.01ef355f@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2009 01:34 AM, Arjan van de Ven wrote:
> Wu Fengguang<fengguang.wu@intel.com>  wrote:
>> Maybe this is enough for POWERTOP, however for general use, the dirty
>> type(data/metadata) and inode number may be valuable to some users?
>
> what can a user do with an inode number????

Inode numbers have always been visible to userspace...  IIRC, tar(1) 
uses the st_ino member of struct stat to detect hard links in certain 
cases.  ls(1) displays inode numbers with -i, find(1) looks for them 
with -inum, ...

	Jeff


