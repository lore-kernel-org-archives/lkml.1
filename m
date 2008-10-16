Return-Path: <linux-kernel-owner+w=401wt.eu-S1757558AbYJPTSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbYJPTSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 15:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756674AbYJPTSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 15:18:35 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:9377 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241AbYJPTSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 15:18:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:references:date:in-reply-to:message-id:user-agent
         :mime-version:content-type:from;
        b=p4poD2UM+r8+TLz44A/ZSMXEBSjHhFmixU6Xvwu8i1gbjJlHIEdtwih2DTM8NVDVw4
         SfPSUuZ5iKvveKd+mqus+hQuzpmq2rM8duJv49T1NvHzKEaIT3egwJ0UoEpN6qRHaiUE
         /BywcjkFEVXVV1sU3+e1xCmnOoSw7hWdoUnFA=
To: Theodore Tso <tytso@mit.edu>
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: ext2, ext3, ext4 config headlines inconsistent:
References: <adaod1nvx98.fsf@cisco.com> <20081016151559.GB12962@mit.edu>
Date: Thu, 16 Oct 2008 21:18:27 +0200
In-Reply-To: <20081016151559.GB12962@mit.edu> (Theodore Tso's message of "Thu,
	16 Oct 2008 11:15:59 -0400")
Message-ID: <87abd45oxo.fsf@basilikum.skogtun.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: Harald Arnesen <skogtun.harald@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso <tytso@mit.edu> writes:

> On Tue, Oct 14, 2008 at 11:37:23AM -0700, Roland Dreier wrote:
>> Hi Ted,
>> 
>> While running an oldconfig with the new kernel, I got the following prompt:
>> 
>>     Second extended fs support (EXT2_FS) [N/m/y/?] n
>>     Ext3 journalling file system support (EXT3_FS) [N/m/y/?] n
>>     The Extended 4 (ext4) filesystem (EXT4_FS) [N/m/y/?] (NEW) n
>> 
>> the lack of parallelism in the headline prompts is a little jarring.
>> Any interest in a patch to make this look uniform, or is it not worth
>> it?  If you are interested, which variant do you prefer?
>
> I'll note that we don't have consistency across all of the entries in
> fs/Kconfig, not just ext2/ext3/ext4.  If it were just up to me I'd
> probably prefer:
>
>     Ext2 file system support (EXT2_FS) [N/m/y/?] n
>     Ext3 file system support (EXT3_FS) [N/m/y/?] n
>     Ext4 file system support (EXT4_FS) [N/m/y/?] (NEW) n
>
> ... but it might be worth looking at the other entries in fs/Kconfig
> as well.

Something completely different - Documentation/filesystems/ext4:

  - When comparing performance with other filesystems, remember that
    ext3/4 by default offers higher data integrity guarantees than most.
    So when comparing with a metadata-only journalling filesystem, such
    as ext3, use `mount -o data=writeback'.  And you might as well use
       ^^^^
    `mount -o nobh' too along with it.  Making the journal larger than
    the mke2fs default often helps performance with metadata-intensive
    workloads.

Anything _but_ ext3 here?
-- 
Hilsen Harald.
