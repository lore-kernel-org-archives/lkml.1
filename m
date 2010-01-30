Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543Ab0A3OyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab0A3OyR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 09:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592Ab0A3OyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 09:54:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab0A3OyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 09:54:15 -0500
Message-ID: <4B6447EC.7030702@redhat.com>
Date: Sat, 30 Jan 2010 09:53:32 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Christoph Lameter <cl@linux-foundation.org>,
       Dave Chinner <david@fromorbit.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Miklos Szeredi <miklos@szeredi.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Subject: Re: Slab Fragmentation Reduction V15
References: <20100129204931.789743493@quilx.com> <20100130104812.GE29555@one.firstfloor.org>
In-Reply-To: <20100130104812.GE29555@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2010 05:48 AM, Andi Kleen wrote:
> On Fri, Jan 29, 2010 at 02:49:31PM -0600, Christoph Lameter wrote:

>> 	1. Establish a reference to an dentry/inode so that it is pinned.
>>             Hopefully in a way that is not too expensive (i.e. no superblock
>>             lock)
>>
>> 	2. A means to free a dentry/inode objects from the VM reclaim context.
>
>
> Al, do you have a suggestions on a good way to do that?

You cannot free inode objects for files that are open, mmapped, etc.

> I guess the problem could be simplified by ignoring dentries in "unusual"
> states?

You mean dentries that are in use? :)

-- 
All rights reversed.
