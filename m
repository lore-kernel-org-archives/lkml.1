Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbYIJNly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbYIJNly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 09:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbYIJNlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 09:41:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51890 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbYIJNlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 09:41:45 -0400
Message-ID: <48C7CDF4.2020206@redhat.com>
Date: Wed, 10 Sep 2008 08:39:00 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] include <linux/fs.h> into linux/ext2_fs.h
References: <1221045726-5674-1-git-send-email-kirill@shutemov.name> <20080910112709.GA11742@infradead.org> <20080910114011.GB3757@localhost.localdomain> <20080910114042.GA15996@infradead.org> <20080910114923.GC3757@localhost.localdomain>
In-Reply-To: <20080910114923.GC3757@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill A. Shutemov wrote:
> On Wed, Sep 10, 2008 at 07:40:42AM -0400, Christoph Hellwig wrote:
>> On Wed, Sep 10, 2008 at 02:40:12PM +0300, Kirill A. Shutemov wrote:
>>> On Wed, Sep 10, 2008 at 07:27:09AM -0400, Christoph Hellwig wrote:
>>>> On Wed, Sep 10, 2008 at 02:22:03PM +0300, Kirill A. Shutemov wrote:
>>>>> linux/fs.h defines FS_IOC* needed by linux/ext2_fs.h
>>>> And who cares?  
> 
> Do you think it isn't error?
> 
>>> It breaks building pam_mktemp at least.
>> pam_mktemp should not use <linux/ext2_fs.h>, but rather
>> <ext2fs/ext2_fs.h>.

That's right.

> Why linux/ext2_fs.h does export to userspace?
> 

it does?

$ grep header-y include/linux/Kbuild | wc -l
163
$ grep header-y include/linux/Kbuild | grep ext2
$

I think it does not.

-Eric
