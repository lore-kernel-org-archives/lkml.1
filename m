Return-Path: <linux-kernel-owner+w=401wt.eu-S1759601AbZJMMUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601AbZJMMUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 08:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbZJMMUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 08:20:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:60454 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbZJMMUE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 08:20:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=l81ANexHkf+910K+ymZYkJJn6DSo1LrQHjPtQZHsXd5h4DXADVOzwzJQoZlkvajheg
         rfsddyjWtHOE41Sa7Koy7VJbCLtWmZkPvLEBDOL5z5PvUGzDOhgBFamL4+WBthMU/ITu
         PUEbFPqGMzfppkrBrVJQ2RLkLUiuvEuHqh9AU=
MIME-Version: 1.0
In-Reply-To: <20091013121355.GA8175@mit.edu>
References: <94a0d4530910120651i18ce33d2k89abcd66d1b865a1@mail.gmail.com>
	 <20091012222910.GB18195@mit.edu>
	 <94a0d4530910121602i14f34150h18d388668fc355d9@mail.gmail.com>
	 <20091012231211.GC18195@mit.edu>
	 <94a0d4530910121627j74faac64l29169e17c0b2961b@mail.gmail.com>
	 <20091013010518.GA2606@mit.edu> <20091013021108.GB2606@mit.edu>
	 <94a0d4530910130411y3dd21b07qdda870c268a6b916@mail.gmail.com>
	 <20091013121355.GA8175@mit.edu>
Date: Tue, 13 Oct 2009 15:18:15 +0300
Message-ID: <94a0d4530910130518r55031d91t55f519199d5a3b74@mail.gmail.com>
Subject: Re: Weird ext4 bug: 256P used?
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Theodore Tso <tytso@mit.edu>,
       Felipe Contreras <felipe.contreras@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 3:13 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Tue, Oct 13, 2009 at 02:11:27PM +0300, Felipe Contreras wrote:
>> My compiler fails because this function is already defined at
>> 'lib/ext2fs/ext2fs.h' as non static.
>
> Ah, you must be using a 64-bit 'pu' branch version of e2fsprogs.
> Yeah, this patch was meant for the 'maint' branch.  A sightly
> different branch is needed for the 'pu' branch.

I just used the HEAD:
remotes/origin/HEAD -> origin/master

Anyway, it builds fine on the 'maint' branch :)

Thanks a lot.

-- 
Felipe Contreras
