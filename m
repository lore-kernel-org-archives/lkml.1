Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbYHRSKC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbYHRSKC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:10:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbYHRSJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:09:54 -0400
Received: from mail.lang.hm ([64.81.33.126]:38318 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbYHRSJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:09:53 -0400
Date: Mon, 18 Aug 2008 11:09:31 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Eric Paris <eparis@redhat.com>
cc: tvrtko.ursulin@sophos.com, Theodore Tso <tytso@mit.edu>, davecb@sun.com,
       Adrian Bunk <bunk@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, Casey Schaufler <casey@schaufler-ca.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] scanner interface proposal was:	[TALPA]	Intro	to
 a linux interface for on access scanning
In-Reply-To: <1219081154.15566.73.camel@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0808181107320.15109@asgard.lang.hm>
References: <20080818153212.6A6FD33687F@pmx1.sophos.com>  <1219076143.15566.39.camel@localhost.localdomain>  <alpine.DEB.1.10.0808181015070.15109@asgard.lang.hm> <1219081154.15566.73.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008, Eric Paris wrote:

> On Mon, 2008-08-18 at 10:29 -0700, david@lang.hm wrote:
>> On Mon, 18 Aug 2008, Eric Paris wrote:
>>
>>> ******************************
>>>
>>> Great, how to build this interface.  THIS IS WHAT I ACTUALLY CARE ABOUT
>>>
>>> The communication with userspace has a very specific need.  The scanning
>>> process needs to get 'something' that will give it access to the
>>> original file/inode/data being worked on.  My previous patch set does
>>> this with a special securityfs file.  Scanners would block on 'read.'
>>> This block was waiting for something to be scanned and when available a
>>> dentry_open() was called in the context of the scanner for the inode in
>>> question.  This means that the fd in the scanner had to be the same data
>>> as the fd in the original process.
>>
>> having scanners access a file blocking on read won't work for multiple
>> scanners (unless you are going to create multiple files for them to read)
>
> WHAT?

if you have multiple things reading from a pipe only one will get any one 
message, right?

David Lang
